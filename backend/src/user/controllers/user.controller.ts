import { Body, Controller, Delete, Get, Param, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiHeader, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { UserService } from 'src/user/services';
import { User } from '@prisma/client';
import { UserPageModel } from 'src/user/models';
import { EntityPageOptionsDto } from 'src/library/dtos';
import { DeviceEntity, UserEntity } from 'src/user/entities';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { RegisterUserDeviceDto, UserUpdateDto } from 'src/user/dtos';
import { AccessTokenGuard } from 'src/auth/guards';

@Controller()
@ApiTags('user')
@ApiHeader({
  name: 'Authorization',
  description: 'Bearer <access_token>',
})
export class UserController {
  constructor(private readonly userService: UserService) {}

  //@UseGuards(AccessTokenGuard)
  @Get('/user/:id')
  @ApiOkResponse({ type: UserEntity })
  async getUserById(@Param('id', ParseUUIDStringPipe) id: string): Promise<UserEntity> {
    return this.userService.findUser({ id });
  }

  //@UseGuards(AccessTokenGuard)
  @Get('user')
  @ApiOkResponse({ type: UserEntity })
  async getUserByEmail(@Query('email') email: string): Promise<UserEntity> {
    return this.userService.findUser({ email });
  }

  //@UseGuards(AccessTokenGuard)
  @Get('/users')
  @ApiOkResponse({ type: UserPageModel })
  async getUsers(@Query() pageOptionsDto: EntityPageOptionsDto): Promise<UserPageModel> {
    return this.userService.findUsers({ ...pageOptionsDto });
  }

  //@UseGuards(AccessTokenGuard)
  @Put('user/:id')
  @ApiOkResponse({ type: UserEntity })
  async updateUser(@Param('id', ParseUUIDStringPipe) id: string, @Body() userData: UserUpdateDto): Promise<UserEntity> {
    return this.userService.updateUser({
      where: { id },
      data: userData,
    });
  }

  //@UseGuards(AccessTokenGuard)
  @Delete('user/:id')
  @ApiOkResponse({ type: UserEntity })
  async deleteUser(@Param('id', ParseUUIDStringPipe) id: string): Promise<UserEntity> {
    return this.userService.deleteUser({ id });

    // TODO: Also delete user's cognitoId.
  }

  //@UseGuards(AccessTokenGuard)
  @Post('user/device')
  @ApiOkResponse({ type: DeviceEntity })
  async registerUserDevice(@Body() registerUserDeviceData: RegisterUserDeviceDto): Promise<DeviceEntity> {
    return this.userService.registerUserDevice(registerUserDeviceData);
  }
}
