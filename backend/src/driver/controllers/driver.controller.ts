import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { ApiCreatedResponse, ApiHeader, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from 'src/auth/guards';
import { DriverCreateDto } from 'src/driver/dtos';
import { DriverService } from 'src/driver/services';
import { DriverEntity } from 'src/driver/entities/driver.entity';

@Controller()
@ApiTags('driver')
@ApiHeader({
  name: 'Authorization',
  description: 'Bearer <access_token>',
})
export class DriverController {
  constructor(private readonly driverService: DriverService) {}

  @Post('/driver')
  @UseGuards(AccessTokenGuard)
  @ApiCreatedResponse({ type: DriverEntity })
  async createUser(@Body() driverData: DriverCreateDto): Promise<DriverEntity> {
    return this.driverService.createDriver(driverData);
  }
}
