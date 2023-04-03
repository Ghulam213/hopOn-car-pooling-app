import { ApiProperty } from '@nestjs/swagger';
import { IsDefined, IsNotEmpty, IsString, IsUUID } from 'class-validator';
import { Trim } from 'src/library/decorators';

export class LocationUpdateDto {
  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsDefined()
  @IsUUID()
  rideId: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsDefined()
  @IsUUID()
  entityId: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  currentLocation: string;
}
