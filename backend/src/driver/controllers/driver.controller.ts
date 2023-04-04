import { Body, Controller, Delete, Get, Param, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiCreatedResponse, ApiHeader, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from 'src/auth/guards';
import { DriverCreateDto, DriverUpdateDto } from 'src/driver/dtos';
import { DriverService } from 'src/driver/services';
import { DriverEntity } from 'src/driver/entities/driver.entity';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { DriverPageModel } from 'src/driver/models';
import { EntityPageOptionsDto } from 'src/library/dtos';
import { VehicleEntity } from 'src/driver/entities/vehicle.entity';

@Controller()
@ApiTags('driver')
@ApiHeader({
  name: 'Authorization',
  description: 'Bearer <access_token>',
})
export class DriverController {
  constructor(private readonly driverService: DriverService) {}

  //@UseGuards(AccessTokenGuard)
  @Post('/driver')
  @ApiCreatedResponse({ type: DriverEntity })
  async createDriver(@Body() driverData: DriverCreateDto): Promise<DriverEntity> {
    return this.driverService.createDriver(driverData);
  }

  //@UseGuards(AccessTokenGuard)
  @Get('/driver/:id')
  @ApiOkResponse({ type: DriverEntity })
  async getDriverById(@Param('id', ParseUUIDStringPipe) id: string): Promise<DriverEntity> {
    return this.driverService.findDriver({ id });
  }

  //@UseGuards(AccessTokenGuard)
  @Get('driver')
  @ApiOkResponse({ type: DriverEntity })
  async getDriverByUserId(@Query('userId', ParseUUIDStringPipe) userId: string): Promise<DriverEntity> {
    return this.driverService.findDriver({ userId });
  }

  //@UseGuards(AccessTokenGuard)
  @Get('/drivers')
  @ApiOkResponse({ type: DriverPageModel })
  async getDrivers(@Query() pageOptionsDto: EntityPageOptionsDto): Promise<DriverPageModel> {
    return this.driverService.findDrivers({ ...pageOptionsDto });
  }

  //@UseGuards(AccessTokenGuard)
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

  //@UseGuards(AccessTokenGuard)
  @Delete('driver/:id')
  @ApiOkResponse({ type: DriverEntity })
  async deleteDriver(@Param('id', ParseUUIDStringPipe) id: string): Promise<DriverEntity> {
    return this.driverService.deleteDriver({ id });
  }

  //@UseGuards(AccessTokenGuard)
  @Post('driver/:id/verify')
  @ApiOkResponse({ type: DriverEntity })
  async verifyDriver(@Param('id', ParseUUIDStringPipe) id: string): Promise<DriverEntity> {
    return this.driverService.verifyDriver({ id });
  }

  //@UseGuards(AccessTokenGuard)
  @Get('driver/:id/vehicles')
  @ApiOkResponse({ isArray: true, type: VehicleEntity })
  async getVehicleOfDriver(@Param('id', ParseUUIDStringPipe) id: string): Promise<VehicleEntity[]> {
    return this.driverService.getVehiclesOfDriver({ id });
  }

  // TODO: Add a controller to add a vehicle to a driver
}
