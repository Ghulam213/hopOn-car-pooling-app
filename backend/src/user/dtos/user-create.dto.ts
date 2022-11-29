import { ApiProperty } from '@nestjs/swagger';
import {
  // IsBoolean,
  // IsDate,
  IsDefined,
  IsEmail,
  IsNotEmpty,
  // IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';
import { Trim } from 'src/library/decorators';

export class UserCreateDto {
  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsEmail()
  @MaxLength(255)
  @IsString()
  @IsDefined()
  email: string;

  // @MaxLength(255)
  // @IsString()
  // @IsDefined()
  // password: string;

  // @IsNotEmpty()
  // @MaxLength(255)
  // @IsString()
  // @IsOptional()
  // phone?: string;

  // @MaxLength(255)
  // @IsString()
  // @Trim()
  // @IsOptional()
  // firstName?: string;

  // @MaxLength(255)
  // @IsString()
  // @Trim()
  // @IsOptional()
  // lastName?: string;

  // @MaxLength(255)
  // @IsString()
  // @IsOptional()
  // locale?: string;

  // @MaxLength(255)
  // @IsString()
  // @IsOptional()
  // timezone?: string;

  // @MaxLength(255)
  // @IsString()
  // @IsDefined()
  // roqIdentifier: string;

  // @IsDate()
  // @IsOptional()
  // optedInAt?: Date;

  // @IsBoolean()
  // @IsOptional()
  // active?: boolean;

  // @IsBoolean()
  // @IsOptional()
  // sync?: boolean;
}
