import { ApiProperty } from '@nestjs/swagger';
import { Prisma, RideStatusEnum } from '@prisma/client';
import { IsDateString, IsEnum, IsNotEmpty, IsOptional, IsString, MaxLength } from 'class-validator';

export class RideUpdateDto implements Prisma.RideUpdateInput {
  @ApiProperty({ required: false })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  @IsOptional()
  currentLocation?: string;

  @ApiProperty({ enum: RideStatusEnum, required: false })
  @IsEnum(RideStatusEnum)
  @IsNotEmpty()
  @IsOptional()
  rideStatus?: RideStatusEnum;

  @ApiProperty({ required: false })
  @IsDateString()
  @IsNotEmpty()
  @IsOptional()
  rideEndedAt?: Date;
}
