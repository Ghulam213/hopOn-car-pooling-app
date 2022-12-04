import { User, GenderEnum, CurrentModeEnum } from '@prisma/client';
import { ApiProperty } from '@nestjs/swagger';

export class UserEntity implements Omit<User, 'password'> {
  @ApiProperty()
  id: string;

  @ApiProperty()
  email: string;

  @ApiProperty()
  firstName: string;

  @ApiProperty()
  lastName: string;

  @ApiProperty()
  phone: string | null;

  @ApiProperty()
  locale: string | null;

  @ApiProperty()
  timezone: string | null;

  @ApiProperty()
  currentCity: string;

  @ApiProperty({ enum: GenderEnum })
  gender: GenderEnum;

  @ApiProperty()
  birthDate: Date;

  @ApiProperty()
  profilePic: string;

  @ApiProperty()
  optedInAt: boolean;

  @ApiProperty()
  active: boolean;

  @ApiProperty()
  verified: boolean;

  @ApiProperty({ enum: CurrentModeEnum })
  currentMode: CurrentModeEnum;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
