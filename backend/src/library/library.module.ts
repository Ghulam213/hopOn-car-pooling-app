import { Module } from '@nestjs/common';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { UtilityService } from 'src/library/services';

@Module({
  imports: [],
  providers: [UtilityService, ParseUUIDStringPipe],
  exports: [UtilityService],
  controllers: [],
})
export class LibraryModule {}
