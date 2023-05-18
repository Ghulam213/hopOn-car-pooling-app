import { Body, Controller, Delete, Get, Param, Post, Put, Query } from '@nestjs/common';
import { ApiCreatedResponse, ApiHeader, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { DriverCreateDto, DriverUpdateDto } from 'src/driver/dtos';
import { UpsertDriverPreferencesDto } from 'src/driver/dtos/upsert-driver-preferences.dto';
import { DriverRidePreferencesEntity } from 'src/driver/entities/driver-ride-preferences';
import { DriverEntity } from 'src/driver/entities/driver.entity';
import { VehicleEntity } from 'src/driver/entities/vehicle.entity';
import { DriverPageModel } from 'src/driver/models';
import { DriverService } from 'src/driver/services';
import { EntityPageOptionsDto } from 'src/library/dtos';
import { ParseUUIDStringPipe } from 'src/library/pipes';

@Controller()
@ApiTags('driver')
@ApiHeader({
  name: 'Authorization',
  description: 'Bearer <access_token>',
})
export class DriverController {
  constructor(private readonly driverService: DriverService) {}

  // @UseGuards(AccessTokenGuard)
  @Post('/driver')
  @ApiCreatedResponse({ type: DriverEntity })
  async createDriver(@Body() driverData: DriverCreateDto): Promise<DriverEntity> {
    return this.driverService.createDriver(driverData);
  }

  // @UseGuards(AccessTokenGuard)
  @Get('/driver/:id')
  @ApiOkResponse({ type: DriverEntity })
  async getDriverById(@Param('id', ParseUUIDStringPipe) id: string): Promise<DriverEntity> {
    return this.driverService.findDriver({ id });
  }

  // @UseGuards(AccessTokenGuard)
  @Get('driver')
  @ApiOkResponse({ type: DriverEntity })
  async getDriverByUserId(@Query('userId', ParseUUIDStringPipe) userId: string): Promise<DriverEntity> {
    return this.driverService.findDriver({ userId });
  }

  // @UseGuards(AccessTokenGuard)
  @Get('/drivers')
  @ApiOkResponse({ type: DriverPageModel })
  async getDrivers(@Query() pageOptionsDto: EntityPageOptionsDto): Promise<DriverPageModel> {
    return this.driverService.findDrivers({ ...pageOptionsDto });
  }

  // @UseGuards(AccessTokenGuard)
  @Put('driver/:id')
  @ApiOkResponse({ type: DriverEntity })
  async updateDriver(
    @Param('id', ParseUUIDStringPipe) id: string,
    @Body() userData: DriverUpdateDto,
  ): Promise<DriverEntity> {
    return this.driverService.updateDriver({
      where: { id },
      data: userData,
    });
  }

  // @UseGuards(AccessTokenGuard)
  @Delete('driver/:id')
  @ApiOkResponse({ type: DriverEntity })
  async deleteDriver(@Param('id', ParseUUIDStringPipe) id: string): Promise<DriverEntity> {
    return this.driverService.deleteDriver({ id });
  }

  // @UseGuards(AccessTokenGuard)
  @Post('driver/:id/verify')
  @ApiOkResponse({ type: DriverEntity })
  async verifyDriver(@Param('id', ParseUUIDStringPipe) id: string): Promise<DriverEntity> {
    return this.driverService.verifyDriver({ id });
  }

  // @UseGuards(AccessTokenGuard)
  @Get('driver/:id/vehicles')
  @ApiOkResponse({ isArray: true, type: VehicleEntity })
  async getVehicleOfDriver(@Param('id', ParseUUIDStringPipe) id: string): Promise<VehicleEntity[]> {
    return this.driverService.getVehiclesOfDriver({ id });
  }

  // @UseGuards(AccessTokenGuard)
  @Get('driver/:id/preferences')
  @ApiOkResponse({ isArray: true, type: DriverRidePreferencesEntity })
  async getDriverPreferences(@Param('id', ParseUUIDStringPipe) id: string): Promise<DriverRidePreferencesEntity> {
    return this.driverService.getDriverRidePreferences(id);
  }

  // @UseGuards(AccessTokenGuard)
  @Post('driver/:id/preferences')
  @ApiOkResponse({ type: DriverRidePreferencesEntity })
  async upsertDriverPreferences(
    @Param('id', ParseUUIDStringPipe) driverId: string,
    @Body() data: UpsertDriverPreferencesDto,
  ): Promise<DriverRidePreferencesEntity> {
    return this.driverService.upsertDriverRidePreferences({
      driverId,
      data,
    });
  }
}
