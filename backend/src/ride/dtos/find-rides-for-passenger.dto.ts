import { ApiProperty } from '@nestjs/swagger';
import { IsDefined, IsNotEmpty, IsNumberString, IsString, IsUUID } from 'class-validator';
import { Trim } from 'src/library/decorators';

export class FindRidesForPassengerDto {
  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsUUID()
  @IsDefined()
  passengerId: string;

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
  @IsString()
  @IsDefined()
  city: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsNumberString()
  @IsDefined()
  distance: number;
}
