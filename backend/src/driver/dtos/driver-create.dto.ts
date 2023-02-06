import { ApiProperty } from '@nestjs/swagger';
import { Prisma } from '@prisma/client';
import { IsDefined, IsNotEmpty, IsString, IsUUID } from 'class-validator';
import { CreateDriverVehicleDto } from 'src/driver/dtos/create-driver-vehicle.dto';
import { Trim } from 'src/library/decorators';

export class DriverCreateDto implements Omit<Prisma.DriverCreateInput, 'user' | 'vehicles'> {
  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  cnicFront: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  cnicBack: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  licenseFront: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  licenseBack: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsUUID()
  @IsDefined()
  userId: string;

  @ApiProperty({ type: CreateDriverVehicleDto })
  @IsDefined()
  vehicle: CreateDriverVehicleDto;
}
