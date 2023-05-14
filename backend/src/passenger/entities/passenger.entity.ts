import { ApiProperty } from '@nestjs/swagger';
import { Passenger, PassengerRidePreferences } from '@prisma/client';
import { PassengerRidePreferencesEntity } from 'src/passenger/entities/passenger-ride-preferences.entity';
import { UserEntity } from 'src/user/entities';

export class PassengerEntity implements Passenger {
  @ApiProperty()
  id: string;

  @ApiProperty()
  userId: string;

  @ApiProperty({ type: UserEntity })
  user?: UserEntity;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;

  @ApiProperty({ isArray: true, type: () => PassengerRidePreferencesEntity })
  preferences?: PassengerRidePreferences[];
}
