import { ApiProperty } from '@nestjs/swagger';
import { IsDefined, IsNotEmpty, IsString } from 'class-validator';

export class FileCreateDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  @IsDefined()
  key: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  @IsDefined()
  contentType: string;
}
