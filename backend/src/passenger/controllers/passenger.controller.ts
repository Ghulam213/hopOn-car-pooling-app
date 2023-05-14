import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { ApiHeader, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { UpsertPassengerPreferencesDto } from 'src/passenger/dtos';
import { PassengerRidePreferencesEntity } from 'src/passenger/entities/passenger-ride-preferences.entity';
import { PassengerService } from 'src/passenger/services';

@Controller()
@ApiTags('passenger')
@ApiHeader({
  name: 'Authorization',
  description: 'Bearer <access_token>',
})
export class PassengerController {
  constructor(private readonly passengerService: PassengerService) {}

  //   @UseGuards(AccessTokenGuard)
  @Get('passenger/:id/preferences')
  @ApiOkResponse({ isArray: true, type: PassengerRidePreferencesEntity })
  async getPassengerPreferences(
    @Param('id', ParseUUIDStringPipe) id: string,
  ): Promise<PassengerRidePreferencesEntity[]> {
    return this.passengerService.getPassengerRidePreferences(id);
  }

  // @UseGuards(AccessTokenGuard)
  @Post('passenger/:id/preferences')
  @ApiOkResponse({ type: PassengerRidePreferencesEntity })
  async upsertDriverPreferences(
    @Param('id', ParseUUIDStringPipe) passengerId: string,
    @Body() data: UpsertPassengerPreferencesDto,
  ): Promise<PassengerRidePreferencesEntity> {
    return this.passengerService.upsertPassengerRidePreferences({
      passengerId,
      data,
    });
  }
}
