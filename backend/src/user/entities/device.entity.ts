import { User, GenderEnum, CurrentModeEnum, Device } from '@prisma/client';
import { ApiProperty } from '@nestjs/swagger';
import { UserEntity } from 'src/user/entities';

export class DeviceEntity implements Device {
  @ApiProperty()
  id: string;

  @ApiProperty()
  userId: string;

  @ApiProperty()
  deviceType: string;

  @ApiProperty()
  token: string;

  @ApiProperty({ type: UserEntity })
  user?: UserEntity;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
