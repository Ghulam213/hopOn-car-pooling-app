import { ApiProperty } from '@nestjs/swagger';

class CurrentLocationInfo {
  id: string;
  currentLocation: string;
}

export class RideCacheModel {
  @ApiProperty()
  rideId: string;

  @ApiProperty({
    type: CurrentLocationInfo,
  })
  driver: CurrentLocationInfo;

  @ApiProperty({
    isArray: true,
    type: [CurrentLocationInfo],
  })
  passengers: CurrentLocationInfo[];
}
