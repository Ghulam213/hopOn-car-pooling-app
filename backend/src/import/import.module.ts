import { Module } from '@nestjs/common';
import { ImportConsole } from 'src/import/console';
import { ImportService } from 'src/import/services';
import { PrismaModule } from 'src/prisma';

@Module({
  imports: [PrismaModule],
  providers: [ImportConsole, ImportService],
  exports: [ImportService],
  controllers: [],
})
export class ImportModule {}
