import { ApiProperty } from '@nestjs/swagger';
import {
  // IsBoolean,
  // IsDate,
  IsEmail,
  IsNotEmpty,
  // IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';
import { Trim } from 'src/library/decorators';

export class UserUpdateDto {
  @ApiProperty()
  @IsNotEmpty()
  @IsEmail()
  @Trim()
  @MaxLength(255)
  @IsString()
  email?: string;

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
  // @IsNotEmpty()
  // roqIdentifier?: string;

  // @IsDate()
  // @IsOptional()
  // optedInAt?: Date;

  // @IsBoolean()
  // @IsOptional()
  // sync?: boolean;
}
