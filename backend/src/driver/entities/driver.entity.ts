import { ApiProperty } from '@nestjs/swagger';
import { Driver, DriverRidePreferences, Vehicle } from '@prisma/client';
import { DriverRidePreferencesEntity } from 'src/driver/entities/preferences.entity';
import { VehicleEntity } from 'src/driver/entities/vehicle.entity';
import { UserEntity } from 'src/user/entities';

export class DriverEntity implements Driver {
  @ApiProperty()
  id: string;

  @ApiProperty()
  cnicFront: string;

  @ApiProperty()
  cnicBack: string;

  @ApiProperty()
  licenseFront: string;

  @ApiProperty()
  licenseBack: string;

  @ApiProperty()
  userId: string;

  @ApiProperty({ isArray: true, type: () => VehicleEntity })
  vehicles?: Vehicle[];

  @ApiProperty({ type: UserEntity })
  user?: UserEntity;

  @ApiProperty()
  verified: boolean;

  @ApiProperty()
  active: boolean;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;

  @ApiProperty({ isArray: true, type: () => DriverRidePreferencesEntity })
  preferences?: DriverRidePreferences[];
}
