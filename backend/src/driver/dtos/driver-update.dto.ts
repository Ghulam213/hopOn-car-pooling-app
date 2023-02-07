import { ApiProperty } from '@nestjs/swagger';
import { Prisma } from '@prisma/client';
import { IsBoolean, IsNotEmpty, IsOptional, IsString, MaxLength } from 'class-validator';
import { Trim } from 'src/library/decorators';

export class DriverUpdateDto implements Prisma.DriverUpdateInput {
  @ApiProperty({ required: false })
  @IsString()
  @Trim()
  @IsNotEmpty()
  @IsOptional()
  cnicFront?: string;

  @ApiProperty({ required: false })
  @IsString()
  @Trim()
  @IsNotEmpty()
  @IsOptional()
  cnicBack?: string;

  @ApiProperty({ required: false })
  @IsString()
  @Trim()
  @IsNotEmpty()
  @IsOptional()
  licenseFront?: string;

  @ApiProperty({ required: false })
  @IsString()
  @Trim()
  @IsNotEmpty()
  @IsOptional()
  licenseBack?: string;

  @ApiProperty({ required: false })
  @IsBoolean()
  @IsOptional()
  active?: boolean;

  @ApiProperty({ required: false })
  @IsBoolean()
  @IsOptional()
  verified?: boolean;
}
