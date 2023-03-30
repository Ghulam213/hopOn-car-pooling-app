import { Inject, Injectable } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import { RideStatusEnum } from '@prisma/client';
import { applicationConfig } from 'src/config';
import { DriverService } from 'src/driver/services';
import { UtilityService } from 'src/library/services';
import { PrismaService } from 'src/prisma/services';
import { FindRidesForPassengerDto, RideCreateDto } from 'src/ride/dtos';

@Injectable()
export class RideService {
  constructor(
    @Inject(applicationConfig.KEY)
    private readonly appConfig: ConfigType<typeof applicationConfig>,
    private prisma: PrismaService,
    private readonly driverService: DriverService,
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
}
