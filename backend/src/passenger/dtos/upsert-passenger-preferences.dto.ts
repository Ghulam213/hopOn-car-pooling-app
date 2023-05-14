import { ApiProperty } from '@nestjs/swagger';
import { GenderEnum, Prisma } from '@prisma/client';
import { IsDefined, IsEnum, IsNotEmpty } from 'class-validator';

export class UpsertPassengerPreferencesDto implements Omit<Prisma.PassengerRidePreferencesCreateInput, 'passenger'> {
  @ApiProperty({ enum: GenderEnum })
  @IsEnum(GenderEnum)
  @IsNotEmpty()
  @IsDefined()
  genderPreference: GenderEnum;
}
