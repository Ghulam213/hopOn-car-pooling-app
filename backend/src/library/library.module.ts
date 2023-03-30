import { Module } from '@nestjs/common';
import { FileController } from 'src/library/controllers';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { FileService, UtilityService } from 'src/library/services';
import { NotificationService } from 'src/library/services/notification.service';

@Module({
  imports: [],
  providers: [UtilityService, ParseUUIDStringPipe, FileService, NotificationService],
  exports: [UtilityService, FileService, NotificationService],
  controllers: [FileController],
})
export class LibraryModule {}
