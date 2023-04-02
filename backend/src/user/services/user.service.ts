import { Injectable } from '@nestjs/common';
import { User, Prisma, Device } from '@prisma/client';
import { UserAlreadyExistsException, UserNotFoundException } from 'src/library/exception';
import { PrismaService } from 'src/prisma/services';
import { RegisterUserDeviceDto } from 'src/user/dtos';
import { UserPageModel } from 'src/user/models';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async findUser(
    userWhereUniqueInput: Prisma.UserWhereUniqueInput,
    include?: Prisma.UserInclude,
  ): Promise<User | null> {
    const user = await this.prisma.user.findUnique({
      where: userWhereUniqueInput,
      include,
    });

    if (!user) {
      throw new UserNotFoundException({ variables: { id: userWhereUniqueInput.id } });
    }
    delete user.password;
    return user;
  }

  async findUsers(params: {
    limit?: number;
    offset?: number;
    where?: Prisma.UserWhereInput;
    orderBy?: Prisma.UserOrderByWithRelationInput;
  }): Promise<UserPageModel> {
    const { limit, offset, where, orderBy } = params;
    const [totalCount, data] = await this.prisma.$transaction([
      this.prisma.user.count(),
      this.prisma.user.findMany({
        skip: offset,
        take: limit,
        where,
        orderBy,
      }),
    ]);
    return {
      totalCount,
      data: data.map((u) => {
        delete u.password;
        return { ...u };
      }),
    };
  }

  async createUser(data: Prisma.UserCreateInput): Promise<User> {
    const { phone } = data;
    const userExist = await this.prisma.user.findUnique({ where: { phone } });

    if (userExist) {
      throw new UserAlreadyExistsException({ variables: { phone } });
    }

    return this.prisma.user.create({
      data,
    });
  }

  async updateUser(params: { where: Prisma.UserWhereUniqueInput; data: Prisma.UserUpdateInput }): Promise<User> {
    const { where, data } = params;

    const user = await this.prisma.user.findUnique({ where });

    if (!user) {
      throw new UserNotFoundException({ variables: { id: where.id } });
    }

    const updatedUser = await this.prisma.user.update({
      data,
      where,
    });

    delete updatedUser.password;

    return updatedUser;
  }

  async deleteUser(where: Prisma.UserWhereUniqueInput): Promise<User> {
    const user = await this.prisma.user.findUnique({ where });

    if (!user) {
      throw new UserNotFoundException({ variables: { id: where.id } });
    }

    const deletedUser = await this.prisma.user.delete({
      where,
    });

    delete deletedUser.password;

    return deletedUser;
  }

  async registerUserDevice(registerUserDevice: RegisterUserDeviceDto): Promise<Device> {
    const { userId, ...restOfData } = registerUserDevice;
    return this.prisma.device.upsert({
      create: {
        ...restOfData,
        user: {
          connect: {
            id: userId,
          },
        },
      },
      update: {
        ...restOfData,
      },
      where: {
        userId,
      },
    });
  }
}
