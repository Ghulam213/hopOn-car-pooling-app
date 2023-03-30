import { ApiProperty } from '@nestjs/swagger';
import { Prisma } from '@prisma/client';
import { IsDefined, IsJSON, IsNotEmpty, IsNumber, IsString, IsUUID } from 'class-validator';
import { Trim } from 'src/library/decorators';

export class RideCreateDto
  implements Omit<Prisma.RideCreateInput, 'totalFare' | 'rideStatus' | 'rideStartedAt' | 'rideEndedAt' | 'driver'>
{
  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsUUID()
  @IsDefined()
  driverId: string;

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
  @IsString()
  @IsDefined()
  currentLocation: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsNumber()
  @IsDefined()
  totalDistance: number;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsNumber()
  @IsDefined()
  city: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsJSON()
  @IsDefined()
  polygonPoints: Prisma.JsonArray;
}
