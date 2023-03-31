import { Inject, Injectable } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import { RideStatusEnum } from '@prisma/client';
import { applicationConfig } from 'src/config';
import { DriverService } from 'src/driver/services';
import { RideNotFoundException, UserNotFoundException } from 'src/library/exception';
import { UtilityService } from 'src/library/services';
import { NotificationService } from 'src/library/services/notification.service';
import { PrismaService } from 'src/prisma/services';
import { FindRidesForPassengerDto, RideCreateDto, RideRequestDto } from 'src/ride/dtos';

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
   * This method is called when a passenger requests a ride
   * It will find the ride that the passenger requested and update the ride status to REQUESTED
   * and also publish a message to the SNS topic to notify the driver that a passenger has requested a ride.
   * The driver will then accept or reject the ride request.
   *
   * @param data - RideRequestDto
   */
  async requestRide(data: RideRequestDto) {
    const user = await this.prisma.user.findUnique({
      where: {
        id: data.userId,
      },
    });

    if (!user) {
      throw new UserNotFoundException({
        variables: {
          id: data.userId,
        },
      });
    }

    const ride = await this.prisma.ride.findUnique({
      where: {
        id: data.rideId,
      },
    });

    if (!ride) {
      throw new RideNotFoundException({
        variables: {
          rideId: data.rideId,
        },
      });
    }

    if (ride.rideStatus !== RideStatusEnum.ON_GOING) {
      throw new RideNotFoundException({
        variables: {
          rideId: data.rideId,
        },
      });
    }

    const deviceArn = await this.prisma.device.findUnique({
      where: {
        userId: data.userId,
      },
    });

    if (!deviceArn) {
      throw new RideNotFoundException({
        variables: {
          rideId: data.rideId,
        },
      });
    }

    await this.notificationService.publishMessageToDeviceArn(
      {
        subject: 'Request Ride',
        message: { ...ride },
      },
      deviceArn.token,
    );

    await this.prisma.ride.update({
      where: {
        id: data.rideId,
      },
      data: {
        rideStatus: RideStatusEnum.REQUESTED,
      },
    });

    return ride;
  }
}
