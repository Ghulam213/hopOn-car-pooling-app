import { Controller, Post, UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiHeader, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { FileCreateModel } from 'src/library/models';
import { FileService } from 'src/library/services';
import { uuid } from 'uuidv4';

@Controller()
@ApiTags('file')
@ApiHeader({
  name: 'Authorization',
  description: 'Bearer token',
})
export class FileController {
  constructor(private readonly fileService: FileService) {}

  // @UseGuards(AccessTokenGuard)
  @ApiOkResponse({ type: FileCreateModel })
  @Post('file')
  @UseInterceptors(FileInterceptor('file'))
  async createFile(@UploadedFile() file: Express.Multer.File): Promise<FileCreateModel> {
    const uniqueFileName = `${uuid()}-${file.originalname}`;
    return this.fileService.uploadFile(uniqueFileName, file.buffer);
  }
}
