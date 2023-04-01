import { Body, Controller, Delete, Get, Param, Post, Put, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { AccessTokenGuard } from 'src/auth/guards';
import { RideService } from 'src/ride/services';
import { RideEntity } from 'src/ride/entities';
import { FindRidesForPassengerDto, RideCreateDto, RideUpdateDto } from 'src/ride/dtos';

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
  async createRide(rideCreateData: RideCreateDto): Promise<RideEntity> {
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
  @ApiOkResponse({ type: RideEntity })
  async getRidesForPassenger(rideForPassengerData: FindRidesForPassengerDto): Promise<RideEntity[]> {
    return this.rideService.findRidesForPassenger(rideForPassengerData);
  }
}
