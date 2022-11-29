import { ApiProperty } from '@nestjs/swagger';
import { User } from '@prisma/client';
import { IsArray } from 'class-validator';
import { UserEntity } from 'src/user/entities';

export class UserPageModel {
  @IsArray()
  @ApiProperty({ isArray: true, type: UserEntity })
  data: User[];

  @ApiProperty()
  totalCount: number;
}
