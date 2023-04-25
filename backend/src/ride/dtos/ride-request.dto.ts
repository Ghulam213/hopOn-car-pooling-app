import { ApiProperty } from '@nestjs/swagger';
import { IsDefined, IsNotEmpty, IsNumber, IsOptional, IsString, IsUUID } from 'class-validator';
import { Trim } from 'src/library/decorators';

export class RideRequestDto {
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
  passengerName: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  driverName: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  passengerSource: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  passengerDestination: string;

  @ApiProperty()
  @IsNumber()
  @IsDefined()
  distance: number;

  @ApiProperty()
  @IsNumber()
  @IsDefined()
  fare: number;

  @ApiProperty()
  @IsNumber()
  @IsDefined()
  ETA: number;
}
