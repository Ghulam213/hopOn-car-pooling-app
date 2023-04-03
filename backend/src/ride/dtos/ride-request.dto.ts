import { ApiProperty } from '@nestjs/swagger';
import { IsDefined, IsNotEmpty, IsNumber, IsString, IsUUID } from 'class-validator';
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
