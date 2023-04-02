import { ApiProperty } from '@nestjs/swagger';
import { IsDefined, IsNotEmpty, IsString, IsUUID, MaxLength } from 'class-validator';
import { Trim } from 'src/library/decorators';

export class RegisterUserDeviceDto {
  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsUUID()
  @IsDefined()
  userId: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @MaxLength(255)
  @IsString()
  @IsDefined()
  deviceType: string;

  @ApiProperty()
  @IsString()
  @Trim()
  @IsNotEmpty()
  @IsDefined()
  token: string;
}
