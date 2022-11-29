import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { ApiCreatedResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { UserService } from 'src/user/services';
import { User } from '@prisma/client';
import { UserPageModel } from 'src/user/models';
import { EntityPageOptionsDto } from 'src/library/dtos';
import { UserCreateDto, UserUpdateDto } from 'src/user/dtos';
import { UserEntity } from 'src/user/entities';
import { ParseUUIDStringPipe } from 'src/library/pipes';

@Controller('/user')
@ApiTags('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('/:id')
  @ApiOkResponse({ type: UserEntity })
  async getUserById(
    @Param('id', ParseUUIDStringPipe) id: string,
  ): Promise<User> {
    return this.userService.findOne({ id });
  }

  @Get('/:email')
  @ApiOkResponse({ type: UserEntity })
  async getUserByEmail(@Param('email') email: string): Promise<User> {
    return this.userService.findOne({ email });
  }

  @Get()
  @ApiOkResponse({ type: UserPageModel })
  async getUsers(
    @Query() pageOptionsDto: EntityPageOptionsDto,
  ): Promise<UserPageModel> {
    return this.userService.findMany({ ...pageOptionsDto });
  }

  @Post()
  @ApiCreatedResponse({ type: UserEntity })
  async createUser(@Body() userData: UserCreateDto): Promise<User> {
    return this.userService.createUser(userData);
  }

  @Put('/:id')
  @ApiOkResponse({ type: UserEntity })
  async publishPost(
    @Param('id', ParseUUIDStringPipe) id: string,
    @Body() userData: UserUpdateDto,
  ): Promise<User> {
    return this.userService.updateUser({
      where: { id },
      data: userData,
    });
  }

  @Delete('/:id')
  @ApiOkResponse({ type: UserEntity })
  async deletePost(
    @Param('id', ParseUUIDStringPipe) id: string,
  ): Promise<User> {
    return this.userService.deleteUser({ id });
  }
}
