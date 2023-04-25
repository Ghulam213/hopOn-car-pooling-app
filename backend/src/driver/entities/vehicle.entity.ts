import { ApiProperty } from '@nestjs/swagger';
import { Vehicle, VehicleTypeEnum } from '@prisma/client';
import { DriverEntity } from 'src/driver/entities/driver.entity';

export class VehicleEntity implements Vehicle {
  @ApiProperty()
  id: string;

  @ApiProperty()
  vehicleType: VehicleTypeEnum;

  @ApiProperty()
  vehicleBrand: string;

  @ApiProperty()
  vehicleModel: string;

  @ApiProperty()
  vehicleColor: string;

  @ApiProperty()
  vehiclePhoto: string;

  @ApiProperty()
  vehicleRegImage: string;

  @ApiProperty()
  vehicleRegNo: string;

  @ApiProperty()
  driverId: string;

  @ApiProperty({ type: () => DriverEntity })
  driver?: DriverEntity;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
