import { Body, Controller, Delete, Get, Param, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from 'src/auth/guards';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import {
  FindRidesForPassengerDto,
  LocationUpdateDto,
  PassengerRideStatusUpdateDto,
  RideCreateDto,
  RideRequestDto,
  RideUpdateDto,
} from 'src/ride/dtos';
import { PassengerOnRideEntity, RideEntity } from 'src/ride/entities';
import { RideCacheModel, RideForPassengersModel } from 'src/ride/models';
import { RideService } from 'src/ride/services';

@Controller()
@ApiTags('ride')
@ApiHeader({
  name: 'Authorization',
  description: 'Bearer <access_token>',
})
export class RideController {
  constructor(private readonly rideService: RideService) {}

  @Get('/ride/:id')
  @ApiOkResponse({ type: RideEntity })
  async getRideById(@Param('id', ParseUUIDStringPipe) id: string): Promise<RideEntity> {
    return this.rideService.findRide({ id });
  }

  @Post('/ride')
  @ApiOkResponse({ type: RideEntity })
  async createRide(@Body() rideCreateData: RideCreateDto): Promise<RideEntity> {
    return this.rideService.createRide(rideCreateData);
  }

  @Put('ride/:id')
  @ApiOkResponse({ type: RideEntity })
  async updateRide(@Param('id', ParseUUIDStringPipe) id: string, @Body() rideData: RideUpdateDto): Promise<RideEntity> {
    return this.rideService.updateRide({
      where: { id },
      data: rideData,
    });
  }

  @Delete('ride/:id')
  @ApiOkResponse({ type: RideEntity })
  async deleteRide(@Param('id', ParseUUIDStringPipe) id: string): Promise<RideEntity> {
    return this.rideService.deleteRide({ id });
  }

  @Get('ride-for-passenger')
  @ApiOkResponse({ type: RideForPassengersModel, isArray: true })
  async getRidesForPassenger(
    @Query() rideForPassengerData: FindRidesForPassengerDto,
  ): Promise<RideForPassengersModel[]> {
    return this.rideService.findRidesForPassenger(rideForPassengerData);
  }

  @Post('ride/request')
  @ApiOkResponse({ type: Boolean })
  async requestForRide(@Body() rideRequestData: RideRequestDto): Promise<true> {
    return this.rideService.requestRide(rideRequestData);
  }

  @Post('ride/accept-request')
  @ApiOkResponse({ type: Boolean })
  async accpetRideRequest(@Body() rideRequestData: RideRequestDto): Promise<true> {
    return this.rideService.requestRideAccept(rideRequestData);
  }

  @Post('ride/reject-request')
  @ApiOkResponse({ type: Boolean })
  async rejectRideRequest(@Body() rideRequestData: RideRequestDto): Promise<true> {
    return this.rideService.requestRideReject(rideRequestData);
  }

  // @UseGuards(AccessTokenGuard)
  @Post('ride/driver/current-location')
  @ApiOkResponse({ type: Boolean })
  async upsertDriverCurrentLocation(@Body() locationUpdateDto: LocationUpdateDto): Promise<Boolean> {
    return this.rideService.upsertRideLocationInCache(locationUpdateDto, 'driver');
  }

  // @UseGuards(AccessTokenGuard)
  @Post('ride/passenger/current-location')
  @ApiOkResponse({ type: Boolean })
  async upsertPassengerCurrentLocation(@Body() locationUpdateDto: LocationUpdateDto): Promise<Boolean> {
    return this.rideService.upsertRideLocationInCache(locationUpdateDto, 'passenger');
  }

  // @UseGuards(AccessTokenGuard)
  @Get('ride/:rideId/current-location')
  @ApiOkResponse({ type: RideCacheModel })
  async getRideCurrentLocation(@Param('rideId', ParseUUIDStringPipe) rideId: string): Promise<RideCacheModel | null> {
    return this.rideService.getRideCurrentLocationFromCache(rideId);
  }

  @UseGuards(AccessTokenGuard)
  @Get('ride/:rideId/complete')
  @ApiOkResponse({ type: Boolean })
  async completeRide(@Param('rideId', ParseUUIDStringPipe) rideId: string): Promise<Boolean> {
    return this.rideService.completeRide(rideId);
  }

  @UseGuards(AccessTokenGuard)
  @Post('ride/:rideId/end-passenger-ride')
  @ApiOkResponse({ type: PassengerOnRideEntity })
  async endPassengerRide(@Param('rideId', ParseUUIDStringPipe) rideId: string, @Body() data: { passengerId: string }) {
    return this.rideService.completePassengerRide(rideId, data.passengerId);
  }

  @UseGuards(AccessTokenGuard)
  @Post('ride/passenger/status')
  @ApiOkResponse({ type: Boolean })
  async updatePassengerRideStatus(@Body() passengerRideStatusUpdate: PassengerRideStatusUpdateDto): Promise<Boolean> {
    const { rideId, passengerId, status } = passengerRideStatusUpdate;
    return this.rideService.updatePassengerRideStatus(rideId, passengerId, status);
  }

  // @UseGuards(AccessTokenGuard)
  @Get('ride/:rideId/passengers')
  @ApiOkResponse({ isArray: true, type: PassengerOnRideEntity })
  async getPassengersOnRide(@Param('rideId', ParseUUIDStringPipe) rideId: string) {
    return this.rideService.getPassengersOfRide(rideId);
  }
}
