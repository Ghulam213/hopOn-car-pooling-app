import { ApiProperty } from '@nestjs/swagger';
import { UserEntity } from 'src/user/entities';

export class SessionModel {
  @ApiProperty()
  accessToken: string;

  @ApiProperty()
  refreshToken: string;

  @ApiProperty()
  userId: string;

  @ApiProperty()
  user: UserEntity;

  @ApiProperty()
  driverId?: string;

  @ApiProperty()
  passengerId?: string;
}
