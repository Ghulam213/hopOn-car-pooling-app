import { ApiProperty } from '@nestjs/swagger';
import { GenderEnum, Prisma } from '@prisma/client';
import { IsDefined, IsEnum, IsNotEmpty, IsNumber } from 'class-validator';

export class UpsertDriverPreferencesDto implements Omit<Prisma.DriverRidePreferencesCreateInput, 'driver'> {
  @ApiProperty({ enum: GenderEnum })
  @IsEnum(GenderEnum)
  @IsNotEmpty()
  @IsDefined()
  genderPreference: GenderEnum;

  @ApiProperty()
  @IsNotEmpty()
  @IsDefined()
  @IsNumber()
  maxNumberOfPassengers: number;
}
