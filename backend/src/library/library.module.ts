import { Module } from '@nestjs/common';
import { FileController } from 'src/library/controllers';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { FileService, UtilityService } from 'src/library/services';

@Module({
  imports: [],
  providers: [UtilityService, ParseUUIDStringPipe, FileService],
  exports: [UtilityService, FileService],
  controllers: [FileController],
})
export class LibraryModule {}
