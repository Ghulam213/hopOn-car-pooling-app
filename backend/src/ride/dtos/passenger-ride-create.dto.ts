import { ApiProperty } from '@nestjs/swagger';
import { Prisma } from '@prisma/client';
import { IsDefined, IsNotEmpty, IsNumber, IsString, IsUUID } from 'class-validator';
import { Trim } from 'src/library/decorators';
import { isUuid } from 'uuidv4';

export class PassengerRideCreateDto
  implements Omit<Prisma.PassengersOnRideCreateInput, 'fare' | 'rideStatus' | 'ride' | 'passenger'>
{
  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsUUID()
  @IsDefined()
  rideId: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsUUID()
  @IsDefined()
  passengerId: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  source: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  destination: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsNumber()
  @IsDefined()
  distance: number;
}
