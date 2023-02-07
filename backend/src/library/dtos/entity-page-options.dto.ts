import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsEnum, IsInt, IsObject, IsOptional, Max, Min } from 'class-validator';
import { OrderEnum } from 'src/library/enums';

export class EntityPageOptionsDto {
  @ApiPropertyOptional({ enum: OrderEnum, default: OrderEnum.ASC })
  @IsEnum(OrderEnum)
  @IsOptional()
  readonly order?: OrderEnum = OrderEnum.ASC;

  @ApiPropertyOptional({
    minimum: 1,
    maximum: 5000,
    default: 1000,
  })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(5000)
  @IsOptional()
  readonly limit?: number = 1000;

  @ApiPropertyOptional({
    minimum: 0,
    default: 0,
  })
  @Type(() => Number)
  @IsInt()
  @Min(0)
  @IsOptional()
  readonly offset?: number = 0;
}
