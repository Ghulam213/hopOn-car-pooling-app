import { Inject, Injectable } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import { Device, Driver, PasengerRideStatusEnum, Prisma, Ride, RideStatusEnum } from '@prisma/client';
import { NotificationNotSentException } from 'src/library/exception/notificationNotSentException';
import { applicationConfig } from 'src/config';
import { DriverService } from 'src/driver/services';
import {
  PassengerNotFoundException,
  RideNotAvailableFoundException,
  RideNotFoundException,
} from 'src/library/exception';
import { UtilityService } from 'src/library/services';
import { NotificationService } from 'src/library/services/notification.service';
import { PrismaService } from 'src/prisma/services';
import { FindRidesForPassengerDto, PassengerRideCreateDto, RideCreateDto, RideRequestDto } from 'src/ride/dtos';

@Injectable()
export class RideService {
  constructor(
    @Inject(applicationConfig.KEY)
    private readonly appConfig: ConfigType<typeof applicationConfig>,
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
    const { driverId, ...restOfData } = data;

    await this.driverService.findDriver({ id: driverId });

    return this.prisma.ride.create({
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
  }

  async findRide(
    rideWhereUniqueInput: Prisma.RideWhereUniqueInput,
    include?: Prisma.RideInclude,
  ): Promise<(Ride & { driver?: Driver }) | null> {
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

  async findRidesForPassenger(passengerData: FindRidesForPassengerDto) {
    const pasengerDestination = UtilityService.stringToCoordinates(passengerData.destination);
    const pasengerSource = UtilityService.stringToCoordinates(passengerData.source);
    const rides = await this.prisma.ride.findMany({
      where: {
        rideStatus: RideStatusEnum.ON_GOING,
        city: passengerData.city,
      },
    });

    return rides.filter((ride) => {
      const rideDestination = UtilityService.stringToCoordinates(ride.destination);
      const rideCurrentLocation = UtilityService.stringToCoordinates(ride.currentLocation);
      const isDestinationsWithinThreshold = UtilityService.arePointsWithinThreshold(
        pasengerDestination,
        rideDestination,
        this.appConfig.destinationOverlapThreshold,
      );
      const isPassengerOnDriverRouter = UtilityService.isPointOnRouteWithinThreshold(
        pasengerSource,
        ride.polygonPoints as number[][],
        this.appConfig.routeOverlapThreshold,
      );
      const isPassengerWithinThresholdOfDriver = UtilityService.arePointsWithinThreshold(
        pasengerSource,
        rideCurrentLocation,
        this.appConfig.passengerDriverDistanceOverlapThreshold,
      );

      return isDestinationsWithinThreshold && isPassengerOnDriverRouter && isPassengerWithinThresholdOfDriver;
    });
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

  private async isPassengerAvailableForRide(rideId: string) {
    const passengerRide = await this.prisma.passengersOnRide.findUnique({
      where: {
        id: rideId,
      },
    });

    if (!passengerRide) {
      throw new PassengerNotFoundException({
        variables: {
          id: rideId,
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
    const { rideId, passengerId } = rideRequestData;

    const ride = await this.findRide({ id: rideId }, { driver: true });
    const passenger = await this.prisma.passenger.findUnique({ where: { id: passengerId } });
    const deviceArn = await this.findDeviceArnForDriver(ride.driverId);

    if (!passenger) {
      throw new PassengerNotFoundException({ variables: { id: passengerId } });
    }

    if (ride.rideStatus !== RideStatusEnum.ON_GOING) {
      throw new RideNotAvailableFoundException({
        variables: {
          rideId,
        },
      });
    }

    await this.notificationService.publishMessageToDeviceArn(
      {
        subject: 'Request Ride',
        message: { ...rideRequestData, ...ride },
      },
      deviceArn.token,
    );

    return true;
  }

  async requestRideAccept(data: RideRequestDto): Promise<true> {
    const { rideId, passengerId, source, destination, distance } = data;

    await this.isPassengerAvailableForRide(data.rideId);

    await this.createPassengerRide({
      rideId,
      passengerId,
      source,
      destination,
      distance,
    });

    const deviceArn = await this.findDeviceArnForPassenger(passengerId);

    await this.notificationService.publishMessageToDeviceArn(
      {
        subject: 'Request Ride Accept',
        message: { ...data },
      },
      deviceArn.token,
    );

    return true;
  }

  async requestRideReject(data: RideRequestDto): Promise<true> {
    const { rideId, passengerId } = data;

    await this.isPassengerAvailableForRide(rideId);

    const deviceArn = await this.findDeviceArnForPassenger(passengerId);

    await this.notificationService.publishMessageToDeviceArn(
      {
        subject: 'Request Ride Reject',
        message: { ...data },
      },
      deviceArn.token,
    );

    return true;
  }
}
