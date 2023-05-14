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
import { PassengerOnRideEntity } from 'src/ride/entities';
import { RideNotificationTypeEnum } from 'src/ride/enums';
import { PassengerInfoModel, RideCacheModel, RideForPassengersModel, RideSegmentModel } from 'src/ride/models';

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

  /*
   * This function returns the overlapping segments between the route of
   * the passenger and the route of other passengers.
   */
  getOverlappingSegmentsForPassenger(
    route: number[][],
    passengerSource: number[],
    passengerDestination: number[],
    otherPassengers: PassengersOnRide[],
  ): RideSegmentModel[] {
    const overlappingSegments: RideSegmentModel[] = [];
    const passengerRoute = UtilityService.getSegmentOnRoute(route, passengerSource, passengerDestination);
    const passengerRouteDistance = UtilityService.calculatePolygonRouteDistance(passengerRoute);

    for (const otherPassenger of otherPassengers) {
      const passengerSourceToOtherPassengerDestination = UtilityService.getSegmentOnRoute(
        route,
        passengerSource,
        UtilityService.stringToCoordinates(otherPassenger.destination),
      );
      const passengerSourceToOtherPassengerDestinationDistance = UtilityService.calculatePolygonRouteDistance(
        passengerSourceToOtherPassengerDestination,
      );

      passengerSourceToOtherPassengerDestinationDistance > passengerRouteDistance
        ? overlappingSegments.push({
            route: passengerSourceToOtherPassengerDestination,
            distance: passengerSourceToOtherPassengerDestinationDistance,
          })
        : overlappingSegments.push({
            route: passengerRoute,
            distance: passengerRouteDistance,
          });
    }

    return overlappingSegments;
  }

  calculateFareForPassegner = async (rideId: string, passengerInfo: PassengerInfoModel) => {
    const ride = await this.prisma.ride.findUnique({
      where: { id: rideId },
      include: {
        passengersOnRide: true,
      },
    });

    const { passengersOnRide } = ride;
    const { baseFare, perKmFare } = this.appConfig.fare;
    const { source, destination, distance } = passengerInfo;

    if (!passengersOnRide.length) {
      return distance * perKmFare + baseFare;
    }

    const onGoingPassengersOnRide = passengersOnRide.filter((passengerOnRide) => {
      return passengerOnRide.rideStatus === PasengerRideStatusEnum.ON_GOING;
    });
    const totalPassengers = onGoingPassengersOnRide.length + 1;

    const route = ride.polygonPoints as number[][];
    const [passengerSourceCoordinates, passengerDestinationCoordinates] = [source, destination].map((location) =>
      UtilityService.stringToCoordinates(location),
    );
    const passengerRoute = UtilityService.getSegmentOnRoute(
      route,
      passengerSourceCoordinates,
      passengerDestinationCoordinates,
    );
    const overlappingSegments = this.getOverlappingSegmentsForPassenger(
      route,
      passengerSourceCoordinates,
      passengerDestinationCoordinates,
      onGoingPassengersOnRide,
    );
    const sortedOverlappingSegments = [...overlappingSegments].sort((a, b) => a.distance - b.distance);

    const nonRepeatingSegments: RideSegmentModel[] = [];

    for (let i = 0; i < sortedOverlappingSegments.length; i++) {
      let startPoint: number[] = [];
      let endPoint: number[] = [];

      if (i === sortedOverlappingSegments.length - 1) {
        endPoint = sortedOverlappingSegments[i].route[sortedOverlappingSegments[i].route.length - 1];
        startPoint = passengerDestinationCoordinates;
      } else {
        startPoint = sortedOverlappingSegments[i + 1].route[0];
        endPoint = sortedOverlappingSegments[i].route[sortedOverlappingSegments[0].route.length - 1];
      }

      const route = UtilityService.getSegmentOnRoute(passengerRoute, startPoint, endPoint);
      const distance = UtilityService.calculatePolygonRouteDistance(route);
      nonRepeatingSegments.push({ route, distance });
    }

    let fare = baseFare;
    for (let i = 0; i < nonRepeatingSegments.length; i++) {
      const segment = nonRepeatingSegments[i];
      fare += (segment.distance * perKmFare) / (totalPassengers - i);
    }

    return fare;
  };

  /*
   * Returns an estimated time in minutes for the driver to reach the passenger.
   */
  async calculateETAForPassenger(ride: Ride, passengerInfo: PassengerInfoModel) {
    const rideCache = await this.getRideCurrentLocationFromCache(ride.id);
    const rideCurrentLocation = UtilityService.stringToCoordinates(rideCache.driver.currentLocation);
    const passengerSourceCoordinates = UtilityService.stringToCoordinates(passengerInfo.source);

    const distance = UtilityService.getKmDistanceBetweenTwoPoints(rideCurrentLocation, passengerSourceCoordinates);
    const time = distance / this.appConfig.etaPerKm;

    return Math.ceil(time);
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

    const filteredRides = rides.filter((_, index) => promisesResults[index]);

    const ridesForPassenger = await Promise.all(
      filteredRides.map(async (ride) => {
        const alreadySeatedPassengerCount = await this.prisma.passengersOnRide.count({ where: { rideId: ride.id } });
        const fare = await this.calculateFareForPassegner(ride.id, passengerData);
        const ETA = await this.calculateETAForPassenger(ride, passengerData);
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
          fare,
          ETA,
          source: ride.source,
          destination: ride.source,
          distance: passengerData.distance,
        };
      }),
    );

    return ridesForPassenger;
  }

  async completeRide(rideId: string) {
    const ride = await this.findRide({ id: rideId }, { driver: true, passengersOnRide: true });

    ride.passengersOnRide.forEach(async (passengerOnRide) => {
      await this.prisma.passengersOnRide.update({
        where: {
          id: passengerOnRide.id,
        },
        data: {
          rideStatus: PasengerRideStatusEnum.COMPLETED,
        },
      });
    });

    await this.updateRide({
      where: {
        id: rideId,
      },
      data: {
        rideStatus: RideStatusEnum.COMPLETED,
        rideEndedAt: new Date(),
      },
    });

    const deviceArn = await this.findDeviceArnForDriver(ride.driverId);
    await this.notificationService.publishMessageToDeviceArn(
      {
        subject: 'Ride Completed',
        body: `Your ride has been completed`,
        type: RideNotificationTypeEnum.RIDE_COMPLETED,
        data: { rideId },
      },
      deviceArn.token,
    );

    return true;
  }

  async completePassengerRide(rideId: string, passengerId: string): Promise<PassengerOnRideEntity> {
    const passengerOnRide = await this.prisma.passengersOnRide.findFirst({
      where: {
        rideId,
        passengerId,
      },
    });

    if (!passengerOnRide) {
      throw new PassengerNotFoundException({
        variables: {
          id: passengerId,
        },
      });
    }

    const updatedPassenger = await this.prisma.passengersOnRide.update({
      where: {
        id: passengerOnRide.id,
      },
      data: {
        rideStatus: PasengerRideStatusEnum.COMPLETED,
      },
    });

    return {
      ...updatedPassenger,
    };
  }

  async updatePassengerRideStatus(rideId: string, passengerId: string, rideStatus: PasengerRideStatusEnum) {
    const passengerOnRide = await this.prisma.passengersOnRide.findFirst({
      where: {
        rideId,
        passengerId,
      },
    });

    if (!passengerOnRide) {
      throw new PassengerNotFoundException({
        variables: {
          id: passengerId,
        },
      });
    }

    await this.prisma.passengersOnRide.update({
      where: {
        id: passengerOnRide.id,
      },
      data: {
        rideStatus,
      },
    });

    return true;
  }

  async updateAndNotifyRideFareForPassengersOfRide(rideId: string) {
    const ride = await this.findRide({ id: rideId }, { passengersOnRide: true });

    const onGoingPassengersOnRide = ride.passengersOnRide?.filter((passengerOnRide) => {
      return passengerOnRide.rideStatus === PasengerRideStatusEnum.ON_GOING;
    });

    onGoingPassengersOnRide.forEach(async (passengerOnRide) => {
      const fare = await this.calculateFareForPassegner(rideId, {
        source: passengerOnRide.source,
        destination: passengerOnRide.destination,
        distance: passengerOnRide.distance,
      });

      await this.prisma.passengersOnRide.update({
        where: {
          id: passengerOnRide.id,
        },
        data: {
          fare,
        },
      });

      /*
       * TODO: Send notification to passenger about fare update.
       */
      const deviceArn = await this.findDeviceArnForPassenger(passengerOnRide.id);
      await this.notificationService.publishMessageToDeviceArn(
        {
          subject: 'Fare update',
          body: `Your fare has been updated to ${fare}`,
          type: RideNotificationTypeEnum.RIDE_REQUEST,
          data: { fare },
        },
        deviceArn.token,
      );
    });
  }

  async createPassengerRide(data: PassengerRideCreateDto) {
    const { passengerId, rideId, ...restOfData } = data;

    const fare = await this.calculateFareForPassegner(rideId, restOfData);
    const createdRide = await this.prisma.passengersOnRide.create({
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
        fare,
      },
    });
    await this.updateAndNotifyRideFareForPassengersOfRide(rideId);

    return createdRide;
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

  async getPassengersOfRide(rideId: string) {
    const ride = await this.findRide({ id: rideId }, { passengersOnRide: true });
    return ride.passengersOnRide;
  }
}
