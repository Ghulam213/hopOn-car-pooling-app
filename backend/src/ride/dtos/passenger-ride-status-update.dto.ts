import { ApiProperty } from '@nestjs/swagger';
import { PasengerRideStatusEnum } from '@prisma/client';
import { IsDefined, IsNotEmpty, IsString, IsUUID } from 'class-validator';
import { Trim } from 'src/library/decorators';

export class PassengerRideStatusUpdateDto {
  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsDefined()
  @IsUUID()
  rideId: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsDefined()
  @IsUUID()
  passengerId: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  status: PasengerRideStatusEnum;
}
