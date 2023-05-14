import { ApiProperty } from '@nestjs/swagger';
import { GenderEnum } from '@prisma/client';

export class PassengerRidePreferencesEntity implements PassengerRidePreferencesEntity {
  @ApiProperty()
  id: string;

  @ApiProperty()
  passengerId: string;

  @ApiProperty()
  genderPreference: GenderEnum;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
