import { ApiProperty } from '@nestjs/swagger';
import { GenderEnum } from '@prisma/client';

export class RideForPassengersModel {
  @ApiProperty()
  id: string;

  @ApiProperty()
  driverId: string;

  @ApiProperty()
  driverName: string;

  @ApiProperty()
  driverGender: GenderEnum;

  @ApiProperty()
  driverRating: number;

  @ApiProperty()
  vehicleName: string;

  @ApiProperty()
  vehicleRegNo: string;

  @ApiProperty()
  alreadySeatedPassengerCount: number;

  @ApiProperty()
  fare: number;

  @ApiProperty()
  ETA: number;

  @ApiProperty()
  source: string;

  @ApiProperty()
  destination: string;

  @ApiProperty()
  distance: number;
}
