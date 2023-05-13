import { ApiProperty } from '@nestjs/swagger';
import { CurrentModeEnum, GenderEnum, Prisma } from '@prisma/client';
import { IsBoolean, IsDateString, IsEnum, IsNotEmpty, IsOptional, IsString, MaxLength } from 'class-validator';
import { Trim } from 'src/library/decorators';

export class UserUpdateDto implements Prisma.UserUpdateInput {
  @ApiProperty({ required: false })
  @IsString()
  @Trim()
  @IsNotEmpty()
  @MaxLength(255)
  @IsOptional()
  firstName?: string;

  @ApiProperty({ required: false })
  @IsString()
  @Trim()
  @IsNotEmpty()
  @MaxLength(255)
  @IsOptional()
  lastName?: string;

  @ApiProperty({ required: false })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  @IsOptional()
  phone?: string;

  @ApiProperty({ required: false })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  @IsOptional()
  locale?: string;

  @ApiProperty({ required: false })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  @IsOptional()
  timezone?: string;

  @ApiProperty({ required: false })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  @IsOptional()
  currentCity?: string;

  @ApiProperty({ enum: GenderEnum, required: false })
  @IsEnum(GenderEnum)
  @IsNotEmpty()
  @IsOptional()
  gender?: GenderEnum;

  @ApiProperty({ required: false })
  @IsDateString()
  @IsNotEmpty()
  @IsOptional()
  birthDate?: Date;

  @ApiProperty({ required: false })
  @IsString()
  @IsNotEmpty()
  @IsOptional()
  profilePic?: string;

  @ApiProperty({ required: false })
  @IsBoolean()
  @IsOptional()
  optedInAt?: boolean;

  @ApiProperty({ required: false })
  @IsBoolean()
  @IsOptional()
  active?: boolean;

  @ApiProperty({ required: false })
  @IsBoolean()
  @IsOptional()
  verified?: boolean;

  @ApiProperty({ enum: CurrentModeEnum, required: false })
  @IsEnum(CurrentModeEnum)
  @IsNotEmpty()
  @IsOptional()
  currentMode?: CurrentModeEnum;
}
