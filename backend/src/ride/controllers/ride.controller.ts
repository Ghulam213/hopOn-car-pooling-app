import { Body, Controller, Delete, Get, Param, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { AccessTokenGuard } from 'src/auth/guards';
import { RideService } from 'src/ride/services';
import { RideEntity } from 'src/ride/entities';
import {
  FindRidesForPassengerDto,
  LocationUpdateDto,
  RideCreateDto,
  RideRequestDto,
  RideUpdateDto,
} from 'src/ride/dtos';
import { RideCacheModel } from 'src/ride/models';

@Controller()
@ApiTags('ride')
@ApiHeader({
  name: 'Authorization',
  description: 'Bearer <access_token>',
})
export class RideController {
  constructor(private readonly rideService: RideService) {}

  @UseGuards(AccessTokenGuard)
  @Get('/ride/:id')
  @ApiOkResponse({ type: RideEntity })
  async getRideById(@Param('id', ParseUUIDStringPipe) id: string): Promise<RideEntity> {
    return this.rideService.findRide({ id });
  }

  @UseGuards(AccessTokenGuard)
  @Post('/ride')
  @ApiOkResponse({ type: RideEntity })
  async createRide(@Body() rideCreateData: RideCreateDto): Promise<RideEntity> {
    return this.rideService.createRide(rideCreateData);
  }

  @UseGuards(AccessTokenGuard)
  @Put('ride/:id')
  @ApiOkResponse({ type: RideEntity })
  async updateRide(@Param('id', ParseUUIDStringPipe) id: string, @Body() rideData: RideUpdateDto): Promise<RideEntity> {
    return this.rideService.updateRide({
      where: { id },
      data: rideData,
    });
  }

  @UseGuards(AccessTokenGuard)
  @Delete('ride/:id')
  @ApiOkResponse({ type: RideEntity })
  async deleteRide(@Param('id', ParseUUIDStringPipe) id: string): Promise<RideEntity> {
    return this.rideService.deleteRide({ id });
  }

  @UseGuards(AccessTokenGuard)
  @Get('ride-for-passenger')
  @ApiOkResponse({ type: RideEntity, isArray: true })
  async getRidesForPassenger(@Query() rideForPassengerData: FindRidesForPassengerDto): Promise<RideEntity[]> {
    return this.rideService.findRidesForPassenger(rideForPassengerData);
  }

  @UseGuards(AccessTokenGuard)
  @Post('request')
  @ApiOkResponse({ type: Boolean })
  async requestForRide(@Body() rideRequestData: RideRequestDto): Promise<true> {
    return this.rideService.requestRide(rideRequestData);
  }

  @UseGuards(AccessTokenGuard)
  @Post('accept-request')
  @ApiOkResponse({ type: Boolean })
  async accpetRideRequest(@Body() rideRequestData: RideRequestDto): Promise<true> {
    return this.rideService.requestRideAccept(rideRequestData);
  }

  @UseGuards(AccessTokenGuard)
  @Post('reject-request')
  @ApiOkResponse({ type: Boolean })
  async rejectRideRequest(@Body() rideRequestData: RideRequestDto): Promise<true> {
    return this.rideService.requestRideReject(rideRequestData);
  }

  @UseGuards(AccessTokenGuard)
  @Post('ride/driver/current-location')
  @ApiOkResponse({ type: Boolean })
  async upsertDriverCurrentLocation(@Body() locationUpdateDto: LocationUpdateDto): Promise<Boolean> {
    return this.rideService.upsertRideLocationInCache(locationUpdateDto, 'driver');
  }

  @UseGuards(AccessTokenGuard)
  @Post('ride/passenger/current-location')
  @ApiOkResponse({ type: Boolean })
  async upsertPassengerCurrentLocation(@Body() locationUpdateDto: LocationUpdateDto): Promise<Boolean> {
    return this.rideService.upsertRideLocationInCache(locationUpdateDto, 'passenger');
  }

  @UseGuards(AccessTokenGuard)
  @Get('ride/:rideId/current-location')
  @ApiOkResponse({ type: RideCacheModel })
  async getRideCurrentLocation(@Param('rideId', ParseUUIDStringPipe) rideId: string): Promise<RideCacheModel | null> {
    return this.rideService.getRideCurrentLocationFromCache(rideId);
  }
}
