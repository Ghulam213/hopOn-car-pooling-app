
import { ApiProperty } from '@nestjs/swagger';
import {
  IsDefined,
  IsEmail,
  IsNotEmpty,
  IsPhoneNumber,
  IsString,
  MaxLength,
} from 'class-validator';
import { Trim } from 'src/library/decorators';

export class RegisterDto {
  @ApiProperty()
  @MaxLength(255)
  @IsString()
  @IsDefined()
  password: string;

  @ApiProperty({ required: true })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  @IsDefined()
  @IsPhoneNumber()
  phone: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsEmail()
  @MaxLength(255)
  @IsString()
  @IsDefined()
  email: string;

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
}
