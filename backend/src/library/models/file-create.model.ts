import { ApiProperty } from '@nestjs/swagger';

export class FileCreateModel {
  @ApiProperty()
  key: string;

  @ApiProperty()
  fileUrl: string;
}
