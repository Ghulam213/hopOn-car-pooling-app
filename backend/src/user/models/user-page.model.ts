import { ApiProperty } from '@nestjs/swagger';
import { IsArray } from 'class-validator';
import { UserEntity } from 'src/user/entities';

export class UserPageModel {
  @IsArray()
  @ApiProperty({ isArray: true, type: UserEntity })
  data: UserEntity[];

  @ApiProperty()
  totalCount: number;
}
