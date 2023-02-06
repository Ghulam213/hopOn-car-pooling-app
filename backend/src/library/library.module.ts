import { Module } from '@nestjs/common';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { FileService, UtilityService } from 'src/library/services';

@Module({
  imports: [],
  providers: [UtilityService, ParseUUIDStringPipe],
  exports: [UtilityService, FileService],
  controllers: [],
})
export class LibraryModule {}
