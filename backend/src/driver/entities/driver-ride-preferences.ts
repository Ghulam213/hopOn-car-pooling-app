import { ApiProperty } from '@nestjs/swagger';
import { DriverRidePreferences, GenderEnum } from '@prisma/client';

export class DriverRidePreferencesEntity implements DriverRidePreferences {
  @ApiProperty()
  id: string;

  @ApiProperty()
  driverId: string;

  @ApiProperty()
  genderPreference: GenderEnum;

  @ApiProperty()
  maxNumberOfPassengers: number;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
