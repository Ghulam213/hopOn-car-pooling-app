import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/services';
import { Prisma } from '@prisma/client';
import { DriverCreateDto } from 'src/driver/dtos';
import { UserService } from 'src/user/services';
import { DriverNotFoundException } from 'src/library/exception';
import { DriverEntity } from 'src/driver/entities/driver.entity';
import { DriverPageModel } from 'src/driver/models';
import { VehicleEntity } from 'src/driver/entities/vehicle.entity';

@Injectable()
export class DriverService {
  constructor(private prisma: PrismaService, private readonly userService: UserService) {}

  async createDriver(driveCreateDto: DriverCreateDto): Promise<DriverEntity> {
    const { userId, vehicle, ...restOfData } = driveCreateDto;

    await this.userService.findUser({ id: userId });

    return this.prisma.driver.create({
      data: {
        ...restOfData,
        userId,
        vehicles: {
          create: [driveCreateDto.vehicle],
        },
      },
      include: {
        vehicles: true,
      },
    });
  }

  async findDriver(where: Prisma.DriverWhereUniqueInput, include?: Prisma.DriverInclude): Promise<DriverEntity> {
    const driver = await this.prisma.driver.findUnique({ where, include: include && { ...include } });

    if (!driver) {
      throw new DriverNotFoundException({ variables: { ...where } });
    }

    return driver;
  }

  async findDrivers(params: {
    limit?: number;
    offset?: number;
    where?: Prisma.DriverWhereInput;
    orderBy?: Prisma.DriverOrderByWithRelationInput;
  }): Promise<DriverPageModel> {
    const { limit, offset, where, orderBy } = params;
    const [totalCount, data] = await this.prisma.$transaction([
      this.prisma.driver.count(),
      this.prisma.driver.findMany({
        skip: offset,
        take: limit,
        where,
        orderBy,
      }),
    ]);
    return {
      totalCount,
      data,
    };
  }

  async updateDriver(params: {
    where: Prisma.DriverWhereUniqueInput;
    data: Prisma.DriverUpdateInput;
  }): Promise<DriverEntity> {
    const { where, data } = params;

    const driver = await this.prisma.driver.findUnique({ where });

    if (!driver) {
      throw new DriverNotFoundException({ variables: { ...where } });
    }

    return await this.prisma.driver.update({
      data,
      where,
    });
  }

  async deleteDriver(where: Prisma.DriverWhereUniqueInput): Promise<DriverEntity> {
    const driver = await this.prisma.driver.findUnique({ where });

    if (!driver) {
      throw new DriverNotFoundException({ variables: { ...where } });
    }

    return this.prisma.driver.delete({
      where,
    });
  }

  async verifyDriver(where: Prisma.DriverWhereUniqueInput): Promise<DriverEntity> {
    await this.findDriver(where);

    return await this.prisma.driver.update({
      data: {
        verified: true,
        active: true,
      },
      where,
    });
  }

  async getVehiclesOfDriver(where: Prisma.DriverWhereUniqueInput): Promise<VehicleEntity[]> {
    const driver = await this.findDriver(where, { vehicles: true });
    return driver.vehicles;
  }

  async createVehicleOfDriver(params: {
    driverId: string;
    data: Prisma.VehicleCreateWithoutDriverInput;
  }): Promise<VehicleEntity> {
    const { driverId, data } = params;
    await this.findDriver({ id: driverId });

    return this.prisma.vehicle.create({
      data: {
        ...data,
        driverId,
      },
    });
  }
}
