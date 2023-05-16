import { CACHE_MANAGER, Inject, Injectable } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import {
  Device,
  Driver,
  DriverRidePreferences,
  PasengerRideStatusEnum,
  PassengerRidePreferences,
  PassengersOnRide,
  Prisma,
  Ride,
  RideStatusEnum,
  User,
} from '@prisma/client';
import { Cache } from 'cache-manager';
import { applicationConfig } from 'src/config';
import { DriverService } from 'src/driver/services';
import {
  NotificationNotSentException,
  PassengerNotFoundException,
  RideNotAvailableException,
  RideNotFoundException,
} from 'src/library/exception';
import { UtilityService } from 'src/library/services';
import { NotificationService } from 'src/library/services/notification.service';
import { PassengerService } from 'src/passenger/services';
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
import { PassengerInfoModel, RideCacheModel, RideForPassengersModel } from 'src/ride/models';
import { FareService } from 'src/ride/services/fare.service';
import { UserService } from 'src/user/services';

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
    private readonly passengerService: PassengerService,
    private readonly userService: UserService,
    private readonly fareService: FareService,
  ) {
    this.prisma.addMiddleware(async (params, next) => {
      if (params.model === 'Ride') {
        if (params.action === 'findMany') {
          const results: Ride[] = await next(params);
          return results.map((r) => ({ ...r, polygonPoints: JSON.parse(r.polygonPoints as string) }));
        } else if (params.action === 'findUnique' || params.action === 'findFirst') {
          const results: Ride = await next(params);
          if (results) {
            results.polygonPoints = JSON.parse(results.polygonPoints as string);
          }
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
          id: pr.passengerId,
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
          // either a new passenger or the passenger does not belong to the ride.
          if (ride.passengersOnRide.map((pr) => pr.passengerId).includes(locationUpdateDto.entityId)) {
            updatedRideCache.passengers.push({
              id: locationUpdateDto.entityId,
              currentLocation: locationUpdateDto.currentLocation,
            });
          } else {
            throw new PassengerNotFoundException({ variables: { id: locationUpdateDto.entityId } });
          }
        } else {
          updatedRideCache.passengers[passengerIndex].currentLocation = locationUpdateDto.currentLocation;
        }
      }
    }

    await this.setRideCurrentLocationInCache(locationUpdateDto.rideId, updatedRideCache);
    return true;
  }

  estimateFareForNewPassenger = async (rideId: string, passengerInfo: PassengerInfoModel) => {
    const ride = await this.prisma.ride.findUnique({
      where: { id: rideId },
      include: {
        passengersOnRide: true,
      },
    });

    const onGoingPassengersOnRide = ride.passengersOnRide?.filter((passengerOnRide) => {
      return passengerOnRide.rideStatus === PasengerRideStatusEnum.ON_GOING;
    });

    if (!onGoingPassengersOnRide.length) {
      return this.fareService.calculateFare(passengerInfo.distance);
    }

    return this.fareService.estimateFareForNewPassenger(
      UtilityService.stringToCoordinates(passengerInfo.source),
      UtilityService.stringToCoordinates(passengerInfo.destination),
      passengerInfo.distance,
      onGoingPassengersOnRide,
    );
  };

  adjustFareOfPassengersOnRide = async (rideId: string, passengerInfo: PassengerInfoModel) => {
    const ride = await this.prisma.ride.findUnique({
      where: { id: rideId },
      include: {
        passengersOnRide: true,
      },
    });

    const onGoingPassengersOnRide = ride.passengersOnRide?.filter((passengerOnRide) => {
      return passengerOnRide.rideStatus === PasengerRideStatusEnum.ON_GOING;
    });

    if (!onGoingPassengersOnRide.length) {
      return ride.passengersOnRide;
    }

    const adjustedPassengers = this.fareService.adjustFareOfPassengersOnRide(
      UtilityService.stringToCoordinates(passengerInfo.source),
      UtilityService.stringToCoordinates(passengerInfo.destination),
      passengerInfo.distance,
      onGoingPassengersOnRide,
    );

    return adjustedPassengers;
  };

  /*
   * Returns an estimated time in minutes for the driver to reach the passenger.
   */
  async calculateETAForPassenger(ride: Ride, passengerInfo: PassengerInfoModel) {
    const rideCache = await this.getRideCurrentLocationFromCache(ride.id);

    if (!rideCache) return 0;

    const rideCurrentLocation = UtilityService.stringToCoordinates(rideCache.driver.currentLocation);
    const passengerSourceCoordinates = UtilityService.stringToCoordinates(passengerInfo.source);

    const distance = UtilityService.getKmDistanceBetweenTwoPoints(rideCurrentLocation, passengerSourceCoordinates);
    const time = distance / this.appConfig.etaPerKm;

    return Math.ceil(time);
  }

  async matchPreferences(
    passengerPreferences: PassengerRidePreferences,
    driverPreferences: DriverRidePreferences,
    passengerDetails: User,
    driverDetails: User,
  ) {
    const isPassengerPreferencesMatched = passengerPreferences
      ? passengerPreferences.genderPreference === driverDetails.gender
      : true;
    const isDriverPreferencesMatched = driverPreferences
      ? driverPreferences.genderPreference === passengerDetails.gender
      : true;

    return {
      isPassengerPreferencesMatched,
      isDriverPreferencesMatched,
    };
  }

  checkForMaxPassengerCountReached = async (rideId: string, driverPreferences: DriverRidePreferences) => {
    const alreadySeatedPassengerCount = await this.prisma.passengersOnRide.count({ where: { rideId } });
    const isMaxPassengerCountReached = driverPreferences
      ? alreadySeatedPassengerCount >= driverPreferences.maxNumberOfPassengers
      : alreadySeatedPassengerCount >= this.appConfig.maxNumberOfPassengers;

    return isMaxPassengerCountReached;
  };

  async findRidesForPassenger(passengerData: FindRidesForPassengerDto): Promise<RideForPassengersModel[]> {
    const pasengerDestination = UtilityService.stringToCoordinates(passengerData.destination);
    const pasengerSource = UtilityService.stringToCoordinates(passengerData.source);
    const passengerPreferences = await this.passengerService.getPassengerRidePreferences(passengerData.passengerId);
    const passengerDetails = await this.userService.findUserOfPassenger(passengerData.passengerId);

    const rides = await this.prisma.ride.findMany({
      where: {
        rideStatus: RideStatusEnum.ON_GOING,
        city: passengerData.city,
      },
      include: {
        driver: true,
      },
    });

    const promisesResults = await Promise.all(
      rides.map(async (ride) => {
        const rideCache = await this.getRideCurrentLocationFromCache(ride.id);

        if (!rideCache) {
          return false;
        }

        const rideCurrentLocation = UtilityService.stringToCoordinates(rideCache.driver.currentLocation);

        const driverDetails = await this.userService.findUserOfDriver(ride.driverId);
        const driverPreferences = await this.driverService.getDriverRidePreferences(ride.driverId);

        const { isPassengerPreferencesMatched, isDriverPreferencesMatched } = await this.matchPreferences(
          passengerPreferences,
          driverPreferences,
          passengerDetails,
          driverDetails,
        );
        const isMaxPassengerCountReached = await this.checkForMaxPassengerCountReached(ride.id, driverPreferences);

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
          isPassengerSourceOnDriverRoute &&
          isPassengerDestinationOnDriverRoute &&
          isPassengerWithinThresholdOfDriver &&
          isPassengerPreferencesMatched &&
          isDriverPreferencesMatched &&
          !isMaxPassengerCountReached
        );
      }),
    );

    const filteredRides = rides.filter((_, index) => promisesResults[index]);

    const ridesForPassenger = await Promise.all(
      filteredRides.map(async (ride) => {
        const alreadySeatedPassengerCount = await this.prisma.passengersOnRide.count({ where: { rideId: ride.id } });
        const fare = await this.estimateFareForNewPassenger(ride.id, passengerData);
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

  async updateAndNotifyRideFareForPassengersOfRide(rideId: string, passengerInfo: PassengerInfoModel) {
    const updatedPassengers = await this.adjustFareOfPassengersOnRide(rideId, passengerInfo);

    updatedPassengers.forEach(async (passengerOnRide) => {
      await this.prisma.passengersOnRide.update({
        where: {
          id: passengerOnRide.id,
        },
        data: {
          fare: passengerOnRide.fare,
        },
      });

      const deviceArn = await this.findDeviceArnForPassenger(passengerOnRide.id);
      await this.notificationService.publishMessageToDeviceArn(
        {
          subject: 'Fare update',
          body: `Your fare has been updated to ${passengerOnRide.fare}`,
          type: RideNotificationTypeEnum.FARE_UPDATE,
          data: { fare: passengerOnRide.fare },
        },
        deviceArn.token,
      );
    });
  }

  async createPassengerRide(data: PassengerRideCreateDto) {
    const { passengerId, rideId, ...restOfData } = data;

    const fare = await this.estimateFareForNewPassenger(rideId, restOfData);

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
    await this.updateAndNotifyRideFareForPassengersOfRide(rideId, {
      ...restOfData,
    });

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
