import { CACHE_MANAGER, Inject, Injectable } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import { Device, Driver, PasengerRideStatusEnum, PassengersOnRide, Prisma, Ride, RideStatusEnum } from '@prisma/client';
import { Cache } from 'cache-manager';
import { applicationConfig } from 'src/config';
import { DriverService } from 'src/driver/services';
import { PassengerNotFoundException, RideNotAvailableException, RideNotFoundException } from 'src/library/exception';
import { NotificationNotSentException } from 'src/library/exception/notificationNotSentException';
import { UtilityService } from 'src/library/services';
import { NotificationService } from 'src/library/services/notification.service';
import { PrismaService } from 'src/prisma/services';
import {
  FindRidesForPassengerDto,
  LocationUpdateDto,
  PassengerRideCreateDto,
  RideCreateDto,
  RideRequestDto,
} from 'src/ride/dtos';
import { RideNotificationTypeEnum } from 'src/ride/enums';
import { RideCacheModel, RideForPassengersModel } from 'src/ride/models';

@Injectable()
export class RideService {
  constructor(
    @Inject(applicationConfig.KEY)
    private readonly appConfig: ConfigType<typeof applicationConfig>,
    @Inject(CACHE_MANAGER)
    private cacheManager: Cache,
    private prisma: PrismaService,
    private readonly driverService: DriverService,
    private readonly notificationService: NotificationService,
  ) {
    this.prisma.addMiddleware(async (params, next) => {
      if (params.model === 'Ride') {
        if (params.action === 'findMany') {
          const results: Ride[] = await next(params);
          return results.map((r) => ({ ...r, polygonPoints: JSON.parse(r.polygonPoints as string) }));
        } else if (params.action === 'findUnique' || params.action === 'findFirst') {
          const results: Ride = await next(params);
          results.polygonPoints = JSON.parse(results.polygonPoints as string);
          return results;
        }
      }
      return next(params);
    });
  }

  async createRide(data: RideCreateDto): Promise<Ride> {
    const { driverId, currentLocation, ...restOfData } = data;

    await this.driverService.findDriver({ id: driverId });

    const ride = await this.prisma.ride.create({
      data: {
        ...restOfData,
        driver: {
          connect: {
            id: driverId,
          },
        },
        totalFare: 0,
        rideStatus: RideStatusEnum.ON_GOING,
        rideStartedAt: new Date(),
      },
    });

    this.upsertRideLocationInCache({ currentLocation, entityId: driverId, rideId: ride.id }, 'driver');

    return ride;
  }

  async findRide(
    rideWhereUniqueInput: Prisma.RideWhereUniqueInput,
    include?: Prisma.RideInclude,
  ): Promise<(Ride & { driver?: Driver; passengersOnRide?: PassengersOnRide[] }) | null> {
    const ride = await this.prisma.ride.findUnique({
      where: rideWhereUniqueInput,
      include,
    });

    if (!ride) {
      throw new RideNotFoundException({ variables: { rideId: rideWhereUniqueInput.id } });
    }
    return ride;
  }

  async updateRide(params: { where: Prisma.RideWhereUniqueInput; data: Prisma.RideUpdateInput }): Promise<Ride> {
    const { where, data } = params;

    await this.findRide(where);

    const updatedRide = await this.prisma.ride.update({
      data,
      where,
    });

    return updatedRide;
  }

  async deleteRide(where: Prisma.UserWhereUniqueInput): Promise<Ride> {
    await this.findRide(where);

    const deletedRide = await this.prisma.ride.delete({
      where,
    });

    return deletedRide;
  }

  async getRideCurrentLocationFromCache(rideId: string): Promise<RideCacheModel> {
    const baseCacheKey = this.appConfig.rideCurrentLocationCache.baseCacheKey;
    const rideCache = await this.cacheManager.get<RideCacheModel>(`${baseCacheKey}_${rideId}`);
    return rideCache;
  }

  async setRideCurrentLocationInCache(rideId: string, rideCache: RideCacheModel) {
    const { ttl, baseCacheKey } = this.appConfig.rideCurrentLocationCache;
    await this.cacheManager.set(`${baseCacheKey}_${rideId}`, rideCache, ttl);
  }

  async upsertRideLocationInCache(locationUpdateDto: LocationUpdateDto, mode: 'passenger' | 'driver') {
    const ride = await this.findRide({ id: locationUpdateDto.rideId }, { passengersOnRide: true, driver: true });

    const rideCache = await this.getRideCurrentLocationFromCache(locationUpdateDto.rideId);
    let updatedRideCache: RideCacheModel;

    if (rideCache) {
      updatedRideCache = { ...rideCache };
    } else {
      updatedRideCache = {
        rideId: locationUpdateDto.rideId,
        driver: {
          id: ride.driver?.id,
          currentLocation: '',
        },
        passengers: ride.passengersOnRide?.map((pr) => ({
          id: pr.id,
          currentLocation: '',
        })),
      };
    }

    switch (mode) {
      case 'driver':
        updatedRideCache.driver.currentLocation = locationUpdateDto.currentLocation;
        break;
      case 'passenger': {
        const passengerIndex = updatedRideCache.passengers.findIndex((p) => p.id === locationUpdateDto.entityId);
        if (passengerIndex === -1) {
          throw new PassengerNotFoundException({ variables: { id: locationUpdateDto.entityId } });
        }
        updatedRideCache.passengers[passengerIndex].currentLocation = locationUpdateDto.currentLocation;
      }
    }

    await this.setRideCurrentLocationInCache(locationUpdateDto.rideId, updatedRideCache);
    return true;
  }

  async findRidesForPassenger(passengerData: FindRidesForPassengerDto): Promise<RideForPassengersModel[]> {
    const pasengerDestination = UtilityService.stringToCoordinates(passengerData.destination);
    const pasengerSource = UtilityService.stringToCoordinates(passengerData.source);
    const rides = await this.prisma.ride.findMany({
      where: {
        rideStatus: RideStatusEnum.ON_GOING,
        city: passengerData.city,
      },
    });

    const promisesResults = await Promise.all(
      rides.map(async (ride) => {
        const rideCache = await this.getRideCurrentLocationFromCache(ride.id);

        if (!rideCache) {
          return false;
        }

        const rideCurrentLocation = UtilityService.stringToCoordinates(rideCache.driver.currentLocation);

        const isPassengerSourceOnDriverRoute = UtilityService.isPointOnRouteWithinThreshold(
          pasengerSource,
          ride.polygonPoints as number[][],
          this.appConfig.passengerSourceOnRouteThreshold,
        );

        const isPassengerDestinationOnDriverRoute = UtilityService.isPointOnRouteWithinThreshold(
          pasengerDestination,
          ride.polygonPoints as number[][],
          this.appConfig.passengerDestinationOnRouteThreshold,
        );
        const isPassengerWithinThresholdOfDriver = UtilityService.arePointsWithinThreshold(
          pasengerSource,
          rideCurrentLocation,
          this.appConfig.passengerDriverDistanceOverlapThreshold,
        );

        return (
          isPassengerSourceOnDriverRoute && isPassengerDestinationOnDriverRoute && isPassengerWithinThresholdOfDriver
        );
      }),
    );

    // TODO: Calculate fare
    // TODO: Calculate ETA
    const filteredRides = rides.filter((_, index) => promisesResults[index]);
    const ridesForPassenger = await Promise.all(
      filteredRides.map(async (ride) => {
        const alreadySeatedPassengerCount = await this.prisma.passengersOnRide.count({ where: { rideId: ride.id } });
        const driver = await this.prisma.driver.findUnique({
          where: { id: ride.driverId },
          include: { user: true, vehicles: true },
        });
        return {
          id: ride.id,
          driverId: ride.driverId,
          driverName: `${driver?.user.firstName} ${driver?.user.lastName}`,
          driverGender: driver.user.gender,
          driverRating: 0,
          alreadySeatedPassengerCount,
          vehicleName: `${driver?.vehicles[0].vehicleBrand} ${driver?.vehicles[0].vehicleModel}`,
          vehicleRegNo: driver?.vehicles[0].vehicleRegNo,
          fare: 0,
          ETA: 0,
          source: ride.source,
          destination: ride.source,
        };
      }),
    );

    return ridesForPassenger;
  }

  async createPassengerRide(data: PassengerRideCreateDto) {
    const { passengerId, rideId, ...restOfData } = data;

    return this.prisma.passengersOnRide.create({
      data: {
        ...restOfData,
        ride: {
          connect: {
            id: rideId,
          },
        },
        passenger: {
          connect: {
            id: passengerId,
          },
        },
        rideStatus: PasengerRideStatusEnum.ACCEPTED,
        fare: 0,
      },
    });
  }

  private async isPassengerAvailableForRide(rideId: string, passengerId: string) {
    const passengerRide = await this.prisma.passengersOnRide.findFirst({
      where: {
        rideId,
        passengerId,
      },
    });

    if (passengerRide) {
      throw new PassengerNotFoundException({
        variables: {
          id: passengerId,
        },
      });
    }
  }

  private async findDeviceArnForDriver(driverId: string): Promise<Device> {
    const driver = await this.driverService.findDriver({ id: driverId });

    const deviceArn = await this.prisma.device.findUnique({
      where: {
        userId: driver.userId,
      },
    });

    if (!deviceArn) {
      throw new NotificationNotSentException({
        variables: {
          id: driver.userId,
        },
      });
    }

    return deviceArn;
  }

  private async findDeviceArnForPassenger(passengerId: string): Promise<Device> {
    const passenger = await this.prisma.passenger.findUnique({
      where: {
        id: passengerId,
      },
    });

    if (!passenger) {
      throw new PassengerNotFoundException({
        variables: {
          id: passengerId,
        },
      });
    }

    const deviceArn = await this.prisma.device.findUnique({
      where: {
        userId: passenger.userId,
      },
    });

    if (!deviceArn) {
      throw new NotificationNotSentException({
        variables: {
          id: passenger.userId,
        },
      });
    }

    return deviceArn;
  }

  async requestRide(rideRequestData: RideRequestDto): Promise<true> {
    const { rideId, passengerId, passengerName } = rideRequestData;

    const ride = await this.findRide({ id: rideId }, { driver: true });
    const passenger = await this.prisma.passenger.findUnique({ where: { id: passengerId } });
    const deviceArn = await this.findDeviceArnForDriver(ride.driverId);

    if (!passenger) {
      throw new PassengerNotFoundException({ variables: { id: passengerId } });
    }

    if (ride.rideStatus !== RideStatusEnum.ON_GOING) {
      throw new RideNotAvailableException({
        variables: {
          rideId,
        },
      });
    }

    await this.notificationService.publishMessageToDeviceArn(
      {
        subject: 'Request Ride',
        body: `${passengerName} has requested a ride`,
        type: RideNotificationTypeEnum.RIDE_REQUEST,
        data: { ...rideRequestData },
      },
      deviceArn.token,
    );

    return true;
  }

  async requestRideAccept(data: RideRequestDto): Promise<true> {
    const { rideId, passengerId, driverName, passengerSource, passengerDestination, distance } = data;

    await this.isPassengerAvailableForRide(data.rideId, passengerId);

    await this.createPassengerRide({
      rideId,
      passengerId,
      source: passengerSource,
      destination: passengerDestination,
      distance,
    });

    const deviceArn = await this.findDeviceArnForPassenger(passengerId);

    await this.notificationService.publishMessageToDeviceArn(
      {
        subject: 'Request Ride Accepted',
        body: `Your ride request has been accepted by ${driverName}`,
        type: RideNotificationTypeEnum.RIDE_ACCEPTED,
        data: { ...data },
      },
      deviceArn.token,
    );

    return true;
  }

  async requestRideReject(data: RideRequestDto): Promise<true> {
    const { rideId, passengerId, driverName } = data;

    await this.isPassengerAvailableForRide(rideId, passengerId);

    const deviceArn = await this.findDeviceArnForPassenger(passengerId);

    await this.notificationService.publishMessageToDeviceArn(
      {
        subject: 'Request Ride Rejected',
        body: `Your ride request has been rejected by ${driverName}`,
        type: RideNotificationTypeEnum.RIDE_REJECTED,
        data: { ...data },
      },
      deviceArn.token,
    );

    return true;
  }
}
