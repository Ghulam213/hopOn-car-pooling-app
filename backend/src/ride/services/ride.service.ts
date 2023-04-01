import { Inject, Injectable } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import { PasengerRideStatusEnum, RideStatusEnum } from '@prisma/client';
import { applicationConfig } from 'src/config';
import { DriverService } from 'src/driver/services';
import { RideNotFoundException, UserNotFoundException } from 'src/library/exception';
import { NotificationNotSentException } from 'src/library/exception/notificationNotSentException';
import { PassengerNotFoundException } from 'src/library/exception/passengerNotFoundException';
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
  ) {}

  async createRide(data: RideCreateDto) {
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

  /*
   * This method is called when a passenger requests a ride.
   * It publishes a message to the driver's device and updates the ride status to requested.
   * @param data - RideRequestDto
   */
  // async requestRide(data: RideRequestDto) {
  //   const user = await this.prisma.user.findUnique({
  //     where: {
  //       id: data.userId,
  //     },
  //   });

  //   if (!user) {
  //     throw new UserNotFoundException({
  //       variables: {
  //         id: data.userId,
  //       },
  //     });
  //   }

  //   const ride = await this.prisma.ride.findUnique({
  //     where: {
  //       id: data.rideId,
  //     },
  //   });

  //   if (!ride) {
  //     throw new RideNotFoundException({
  //       variables: {
  //         rideId: data.rideId,
  //       },
  //     });
  //   }

  //   if (ride.rideStatus !== RideStatusEnum.ON_GOING) {
  //     throw new RideNotFoundException({
  //       variables: {
  //         rideId: data.rideId,
  //       },
  //     });
  //   }

  //   const deviceArn = await this.prisma.device.findUnique({
  //     where: {
  //       userId: data.userId,
  //     },
  //   });

  //   if (!deviceArn) {
  //     throw new RideNotFoundException({
  //       variables: {
  //         rideId: data.rideId,
  //       },
  //     });
  //   }

  //   await this.notificationService.publishMessageToDeviceArn(
  //     {
  //       subject: 'Request Ride',
  //       message: { ...ride },
  //     },
  //     deviceArn.token,
  //   );

  //   await this.prisma.ride.update({
  //     where: {
  //       id: data.rideId,
  //     },
  //     data: {
  //       rideStatus: RideStatusEnum.REQUESTED,
  //     },
  //   });

  //   return ride;
  // }

  async isPassengerAvailableForRide(data: { rideId: string }) {
    const passengerRide = await this.prisma.passengersOnRide.findUnique({
      where: {
        id: data.rideId,
      },
    });

    if (!passengerRide) {
      throw new PassengerNotFoundException({
        variables: {
          id: data.rideId,
        },
      });
    }
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

  async findDeviceArnForDriver(data: { driverId: string }) {
    const driver = await this.driverService.findDriver({ id: data.driverId });

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

  async findDeviceArnForPassenger(data: { passengerId: string }) {
    const passenger = await this.prisma.passenger.findUnique({
      where: {
        id: data.passengerId,
      },
    });

    if (!passenger) {
      throw new PassengerNotFoundException({
        variables: {
          id: data.passengerId,
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

  async requestRideAccept(data: RideRequestDto) {
    const { rideId, passengerId, source, destination, distance } = data;

    await this.isPassengerAvailableForRide({
      rideId: data.rideId,
    });

    await this.createPassengerRide({
      rideId,
      passengerId,
      source,
      destination,
      distance,
    });

    const deviceArn = await this.findDeviceArnForPassenger({
      passengerId,
    });

    await this.notificationService.publishMessageToDeviceArn(
      {
        subject: 'Request Ride Accept',
        message: { ...data },
      },
      deviceArn.token,
    );
  }
}
