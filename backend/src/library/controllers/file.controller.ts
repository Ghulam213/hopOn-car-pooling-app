import { Controller, Post, UseGuards } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from 'src/auth/guards';
import { FileCreateDto } from 'src/library/dtos';
import { FileService } from 'src/library/services';

@Controller()
@ApiTags('file')
export class FileController {
  constructor(private readonly fileService: FileService) {}

  @UseGuards(AccessTokenGuard)
  @Post('file/getSignedUrl')
  @ApiOkResponse({ type: () => ({ signedUrl: '' }) })
  async updateUser(fileCreateDto: FileCreateDto): Promise<{ signedUrl: string }> {
    const signedUrl = await this.fileService.getS3SignedUrl(fileCreateDto.key, fileCreateDto.contentType);
    return {
      signedUrl,
    };
  }
}
