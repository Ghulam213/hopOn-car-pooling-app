import { ApiProperty } from '@nestjs/swagger';
import { IsDefined, IsNotEmpty, IsPhoneNumber, IsString, MaxLength } from 'class-validator';

export class ResendOptDto {
  @ApiProperty({ required: false })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  @IsDefined()
  @IsPhoneNumber()
  phone: string;
}
