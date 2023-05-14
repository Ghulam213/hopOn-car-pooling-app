import { Injectable } from '@nestjs/common';
import { PassengerRidePreferences, Prisma } from '@prisma/client';
import { PassengerNotFoundException } from 'src/library/exception';
import { UpsertPassengerPreferencesDto } from 'src/passenger/dtos';
import { PassengerEntity } from 'src/passenger/entities/passenger.entity';
import { PrismaService } from 'src/prisma/services';

@Injectable()
export class PassengerService {
  constructor(private prisma: PrismaService) {}

  async findPassenger(
    where: Prisma.PassengerWhereUniqueInput,
    include?: Prisma.PassengerInclude,
  ): Promise<PassengerEntity> {
    const passenger = await this.prisma.passenger.findUnique({ where, include: include && { ...include } });

    if (!passenger) {
      throw new PassengerNotFoundException({
        variables: {
          id: where.id,
        },
      });
    }

    return passenger;
  }

  async getPassengerRidePreferences(passengerId: string) {
    const passenger = await this.findPassenger({ id: passengerId }, { preferences: true });

    return passenger.preferences;
  }

  async upsertPassengerRidePreferences(params: {
    passengerId: string;
    data: UpsertPassengerPreferencesDto;
  }): Promise<PassengerRidePreferences> {
    const { passengerId, data } = params;

    const preferences = await this.getPassengerRidePreferences(passengerId);

    if (preferences.length) {
      return this.prisma.passengerRidePreferences.update({
        where: {
          id: preferences[0].id,
        },
        data,
      });
    }

    return this.prisma.passengerRidePreferences.create({
      data: {
        ...data,
        passengerId,
      },
    });
  }
}
