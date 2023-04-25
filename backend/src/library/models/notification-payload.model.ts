import { ApiProperty } from '@nestjs/swagger';

export class NotificationPayloadModel<T> {
  @ApiProperty()
  subject: string;

  @ApiProperty()
  body: string;

  @ApiProperty()
  type: string;

  @ApiProperty()
  data: T;
}
