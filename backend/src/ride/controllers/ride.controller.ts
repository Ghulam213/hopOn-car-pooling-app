import { Body, Controller, Delete, Get, Param, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { AccessTokenGuard } from 'src/auth/guards';
import { RideService } from 'src/ride/services';
import { RideEntity } from 'src/ride/entities';
import { FindRidesForPassengerDto, RideCreateDto, RideRequestDto, RideUpdateDto } from 'src/ride/dtos';

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
  @ApiOkResponse({ type: RideEntity })
  async getRidesForPassenger(@Query() rideForPassengerData: FindRidesForPassengerDto): Promise<RideEntity[]> {
    return this.rideService.findRidesForPassenger(rideForPassengerData);
  }

  
  @Post('request')
  @ApiOkResponse({ type: Boolean })
  async requestForRide(@Body() rideRequestData: RideRequestDto): Promise<true> {
    return this.rideService.requestRide(rideRequestData);
  }

  
  @Post('accept-request')
  @ApiOkResponse({ type: Boolean })
  async accpetRideRequest(@Body() rideRequestData: RideRequestDto): Promise<true> {
    return this.rideService.requestRideAccept(rideRequestData);
  }

  
  @Post('reject-request')
  @ApiOkResponse({ type: Boolean })
  async rejectRideRequest(@Body() rideRequestData: RideRequestDto): Promise<true> {
    return this.rideService.requestRideReject(rideRequestData);
  }
}
