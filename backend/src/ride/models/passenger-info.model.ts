import { ApiProperty } from '@nestjs/swagger';

export class PassengerInfoModel {
  @ApiProperty()
  source: string;

  @ApiProperty()
  destination: string;

  @ApiProperty()
  distance: number;
}
