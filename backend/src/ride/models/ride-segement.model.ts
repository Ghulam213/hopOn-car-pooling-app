import { ApiProperty } from '@nestjs/swagger';

export class RideSegmentModel {
  @ApiProperty()
  route: number[][];

  @ApiProperty()
  distance: number;
}
