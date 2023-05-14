import { ApiProperty } from '@nestjs/swagger';
import { PasengerRideStatusEnum, PassengersOnRide } from '@prisma/client';

export class PassengerOnRideEntity implements PassengersOnRide {
  @ApiProperty()
  id: string;
  @ApiProperty()
  rideId: string;
  @ApiProperty()
  passengerId: string;

  @ApiProperty()
  source: string;

  @ApiProperty()
  destination: string;

  @ApiProperty()
  distance: number;

  @ApiProperty()
  fare: number;

  @ApiProperty()
  rideStatus: PasengerRideStatusEnum;

  @ApiProperty()
  rideStartedAt: Date;

  @ApiProperty()
  rideEndedAt: Date;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
