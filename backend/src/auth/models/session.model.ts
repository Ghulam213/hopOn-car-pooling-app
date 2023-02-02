import { ApiProperty } from '@nestjs/swagger';

export class SessionModel {
  @ApiProperty()
  accessToken: string;

  @ApiProperty()
  refreshToken: string;

  @ApiProperty()
  userId: string;
}
