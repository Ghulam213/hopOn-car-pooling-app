import { ApiProperty } from '@nestjs/swagger';
import { Prisma } from '@prisma/client';
import { IsDefined, IsJSON, IsNotEmpty, IsNumber, IsString, IsUUID } from 'class-validator';
import { Trim } from 'src/library/decorators';

export class FindRidesForPassengerDto {
  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  source: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  destination: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsNumber()
  @IsDefined()
  city: string;
}
