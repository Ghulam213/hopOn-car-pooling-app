import { ApiProperty } from '@nestjs/swagger';

export class NotificationPayloadModel<T> {
  @ApiProperty()
  subject: string;

  @ApiProperty()
  message: T;
}
