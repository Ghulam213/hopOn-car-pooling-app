import { CACHE_MANAGER, Inject, Injectable } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import { PassengersOnRide } from '@prisma/client';
import { applicationConfig } from 'src/config';
import { UtilityService } from 'src/library/services';
import { PrismaService } from 'src/prisma/services';

/*
 * This service contains the business logic for the
 * the calculation for the fare of the ride. The
 * fare is allocated among the passengers of the ride.
 * The fare gets updated when new passengers join the
 * ride. The fare is allocted among the passengers
 * based on the distance shared by the passengers.
 *
 * NOTE: Base price and price per kilometer are
 * company set values. Various external factors
 * such as traffic, weather, etc. are not taken
 * into account currently. This will be a future
 * improvement.
 */
@Injectable()
export class FareService {
  constructor(
    @Inject(applicationConfig.KEY)
    private readonly appConfig: ConfigType<typeof applicationConfig>,
    @Inject(CACHE_MANAGER)
    private cacheManager: Cache,
    private prisma: PrismaService,
  ) {}

  /*
   * This function returns the fare given distance
   * based on the company set base price and price
   * per kilometer.
   *
   * @param distance
   * @returns fare
   */
  calculateFare(distance: number) {
    const { baseFare, perKmFare } = this.appConfig.fare;
    const fare = baseFare + distance * perKmFare;

    return fare;
  }

  /*
   * This function calculates the shared distances
   * between the new passenger and the passengers
   * currently on the ride. It takes in the source
   * and destination of the new passenger and returns
   * the distances shared between these points.
   *
   * @param passengerSource : source of the new passenger
   * @param passengerDestination : destination of the new passenger
   * @param passengerRideDistance : distance of the new passenger's ride
   * @param passengersCurrentlyOnRide : passengers currently on the ride
   *
   * @returns sharedDistances : distances shared between the
   * new passenger and the passengers currently on the ride
   * (between source and destination)
   */
  getSharedDistancesForNewPassenger(
    passengerSource: number[],
    passengerDestination: number[],
    passengerRideDistance: number,
    passengersCurrentlyOnRide: PassengersOnRide[],
  ) {
    const segments: number[] = [];

    for (const currentPassenger of passengersCurrentlyOnRide) {
      const passengerSourceToCurrentPassengerDestinationDistance = UtilityService.getKmDistanceBetweenTwoPoints(
        passengerSource,
        UtilityService.stringToCoordinates(currentPassenger.destination),
      );

      const sharedSegment =
        passengerSourceToCurrentPassengerDestinationDistance > passengerRideDistance
          ? passengerRideDistance
          : passengerSourceToCurrentPassengerDestinationDistance;

      segments.push(sharedSegment);
    }

    return segments;
  }

  /*
   * To accurately allocate the fare among the passengers:
   
   * - Calculate the shared distances between the new passenger
   * and the passengers currently on the ride.
   * - Sort the shared distances in ascending order.
   * - Calculate the fare for each shared distance.
   * - Allocate the fare among the passengers based on the
   * shared distance. The shorter distances were shared
   * among more passengers, so the fare for the shorter
   * distances is allocated among more passengers. 
   */
  allocateFareAmongPassengers(sharedDistances: number[], totalPassengers: number) {
    const sortedSharedDistances = sharedDistances.sort((a, b) => a - b);

    let fare = 0;
    for (let i = 0; i < sortedSharedDistances.length; i++) {
      const sharedFare = this.calculateFare(sortedSharedDistances[i]);
      fare += sharedFare / (totalPassengers - i);
    }

    return fare;
  }

  /*
   * This function calculates the fare for the new passenger.
   * It considers the distance that the passenger travelled
   * alone and the distance that the passenger shared with
   * the passengers currently on the ride.
   *
   * @param passengerSource : source of the new passenger
   * @param passengerDestination : destination of the new passenger
   * @param passengerRideDistance : distance of the new passenger's ride
   * @param passengersCurrentlyOnRide : passengers currently on the ride
   *
   * @returns fare : esimated fare for the new passenger
   */
  estimateFareForNewPassenger(
    passengerSource: number[],
    passengerDestination: number[],
    passengerRideDistance: number,
    passengersCurrentlyOnRide: PassengersOnRide[],
  ) {
    const sharedDistances = this.getSharedDistancesForNewPassenger(
      passengerSource,
      passengerDestination,
      passengerRideDistance,
      passengersCurrentlyOnRide,
    );
    const totalPassengers = passengersCurrentlyOnRide.length + 1;

    const allocatedFare = this.allocateFareAmongPassengers(sharedDistances, totalPassengers);
    const aloneFare = this.calculateFare(passengerRideDistance - sharedDistances[sharedDistances.length - 1]);

    const estimatedFare = this.appConfig.fare.baseFare + allocatedFare + aloneFare;

    return estimatedFare;
  }

  /*
   * When a new passenger joins the ride, the fare
   * for each passenger on the ride is adjusted
   * to reflect the new passenger and the distance
   * that the old passengers will now share
   * with the new passenger.
   */
  adjustFareOfPassengersOnRide(
    passengerSource: number[],
    passengerDestination: number[],
    passengerRideDistance: number,
    passengersCurrentlyOnRide: PassengersOnRide[],
  ) {
    const adjustedPassengers = passengersCurrentlyOnRide.map((currentPassenger) => {
      const currentPassengerRideDistance = UtilityService.getKmDistanceBetweenTwoPoints(
        UtilityService.stringToCoordinates(currentPassenger.source),
        UtilityService.stringToCoordinates(currentPassenger.destination),
      );

      const passengerSourceToCurrentPassengerDestinationDistance = UtilityService.getKmDistanceBetweenTwoPoints(
        passengerSource,
        UtilityService.stringToCoordinates(currentPassenger.destination),
      );

      const sharedSegment =
        passengerSourceToCurrentPassengerDestinationDistance > passengerRideDistance
          ? passengerRideDistance
          : passengerSourceToCurrentPassengerDestinationDistance;

      const adjustedDistance = currentPassengerRideDistance - sharedSegment;
      const adjustedFare = this.calculateFare(adjustedDistance);

      return {
        ...currentPassenger,
        fare: adjustedFare,
      };
    });

    return adjustedPassengers;
  }
}
