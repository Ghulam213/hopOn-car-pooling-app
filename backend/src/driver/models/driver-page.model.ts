import { ApiProperty } from '@nestjs/swagger';
import { IsArray } from 'class-validator';
import { DriverEntity } from 'src/driver/entities/driver.entity';

export class DriverPageModel {
  @IsArray()
  @ApiProperty({ isArray: true, type: DriverEntity })
  data: DriverEntity[];

  @ApiProperty()
  totalCount: number;
}
