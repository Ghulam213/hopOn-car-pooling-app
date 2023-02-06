import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/services';
import { Prisma } from '@prisma/client';
import { DriverCreateDto } from 'src/driver/dtos';
import { UserService } from 'src/user/services';

@Injectable()
export class DriverService {
  constructor(private prisma: PrismaService, private readonly userService: UserService) {}

  async createDriver(driveCreateDto: DriverCreateDto) {
    const { userId } = driveCreateDto;

    await this.userService.findUser({ id: userId });

    return this.prisma.driver.create({
      data: {
        ...driveCreateDto,
        vehicles: {
          createMany: {
            data: driveCreateDto.vehicle,
          },
        },
      },
    });
  }
}
