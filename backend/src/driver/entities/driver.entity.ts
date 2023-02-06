import { Driver } from '@prisma/client';
import { ApiProperty } from '@nestjs/swagger';

export class DriverEntity implements Driver {
  @ApiProperty()
  id: string;

  @ApiProperty()
  cnicFront: string;

  @ApiProperty()
  cnicBack: string;

  @ApiProperty()
  licenseFront: string;

  @ApiProperty()
  licenseBack: string;

  @ApiProperty()
  userId: string;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}
