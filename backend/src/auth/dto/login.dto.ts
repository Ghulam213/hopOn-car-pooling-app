import { ApiProperty } from '@nestjs/swagger';
import { IsDefined, IsNotEmpty, IsPhoneNumber, IsString, MaxLength } from 'class-validator';

export class LoginDto {
  @ApiProperty({ required: true })
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

  // @ApiProperty({ required: false })
  // @IsOptional()
  // @IsBoolean()
  // keepMeLoggedIn?: boolean;
}
