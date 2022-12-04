import { ApiProperty } from '@nestjs/swagger';
import { CurrentModeEnum, GenderEnum, Prisma } from '@prisma/client';
import {
  IsBoolean,
  IsDateString,
  IsDefined,
  IsEmail,
  IsEnum,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';
import { Trim } from 'src/library/decorators';

export class UserCreateDto implements Prisma.UserCreateInput {
  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsEmail()
  @MaxLength(255)
  @IsString()
  @IsDefined()
  email: string;

  @ApiProperty()
  @MaxLength(255)
  @IsString()
  @IsDefined()
  password: string;

  @ApiProperty()
  @IsString()
  @Trim()
  @IsNotEmpty()
  @MaxLength(255)
  @IsDefined()
  firstName: string;

  @ApiProperty()
  @IsString()
  @Trim()
  @IsNotEmpty()
  @MaxLength(255)
  @IsDefined()
  lastName: string;

  @ApiProperty({ required: false })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  @IsDefined()
  phone: string;

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

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  @IsDefined()
  currentCity: string;

  @ApiProperty({ enum: GenderEnum })
  @IsEnum(GenderEnum)
  @IsNotEmpty()
  @IsDefined()
  gender: GenderEnum;

  @ApiProperty()
  @IsDateString()
  @IsNotEmpty()
  @IsDefined()
  birthDate: Date;

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

  @ApiProperty({ enum: CurrentModeEnum })
  @IsEnum(CurrentModeEnum)
  @IsNotEmpty()
  @IsDefined()
  currentMode: CurrentModeEnum;
}
