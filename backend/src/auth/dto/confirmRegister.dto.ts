import { ApiProperty } from '@nestjs/swagger';
import { IsDefined, IsNotEmpty, IsPhoneNumber, IsString, MaxLength } from 'class-validator';
import { Trim } from 'src/library/decorators';

export class ConfirmRegisterDto {
  @ApiProperty({ required: false })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  @IsDefined()
  @IsPhoneNumber()
  phone: string;

  @ApiProperty()
  @IsString()
  @Trim()
  @IsNotEmpty()
  @IsDefined()
  code: string;
}
