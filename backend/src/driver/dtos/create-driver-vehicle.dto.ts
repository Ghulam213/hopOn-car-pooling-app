import { ApiProperty } from '@nestjs/swagger';
import { GenderEnum, Prisma, VehicleTypeEnum } from '@prisma/client';
import { IsDefined, IsEnum, IsNotEmpty, IsString } from 'class-validator';
import { Trim } from 'src/library/decorators';

export class CreateDriverVehicleDto implements Omit<Prisma.VehicleCreateInput, 'driver'> {
  @ApiProperty({ enum: GenderEnum })
  @IsEnum(GenderEnum)
  @IsNotEmpty()
  @IsDefined()
  vehicleType: VehicleTypeEnum;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  vehicleBrand: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  vehicleModel: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  vehicleColor: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  vehiclePhoto: string;

  @ApiProperty()
  @Trim()
  @IsNotEmpty()
  @IsString()
  @IsDefined()
  vehicleRegImage: string;
}
