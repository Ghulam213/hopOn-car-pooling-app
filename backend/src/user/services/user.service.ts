import { Injectable } from '@nestjs/common';
import { User, Prisma } from '@prisma/client';
import { UserNotFoundException } from 'src/library/exception';
import { PrismaService } from 'src/prisma.service';
import { UserPageModel } from 'src/user/models';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async findUser(userWhereUniqueInput: Prisma.UserWhereUniqueInput): Promise<User | null> {
    const user = await this.prisma.user.findUnique({
      where: userWhereUniqueInput,
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

    return this.prisma.user.update({
      data,
      where,
    });
  }

  async deleteUser(where: Prisma.UserWhereUniqueInput): Promise<User> {
    const user = await this.prisma.user.findUnique({ where });

    if (!user) {
      throw new UserNotFoundException({ variables: { id: where.id } });
    }

    return this.prisma.user.delete({
      where,
    });
  }
}
