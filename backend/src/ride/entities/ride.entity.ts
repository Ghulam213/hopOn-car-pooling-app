import { Ride, GenderEnum, CurrentModeEnum, RideStatusEnum, Prisma } from '@prisma/client';
import { ApiProperty } from '@nestjs/swagger';

export class RideEntity implements Ride {
  @ApiProperty()
  id: string;

  @ApiProperty()
  driverId: string;

  @ApiProperty()
  source: string;

  @ApiProperty()
  destination: string;

  @ApiProperty()
  totalDistance: number;

  @ApiProperty()
  totalFare: number;

  @ApiProperty({ enum: RideStatusEnum })
  rideStatus: RideStatusEnum;

  @ApiProperty()
  city: string;

  @ApiProperty()
  rideStartedAt: Date | null;

  @ApiProperty()
  rideEndedAt: Date | null;

  @ApiProperty({ type: Prisma['JsonValue'] })
  polygonPoints: Prisma.JsonValue;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
