import { Module } from '@nestjs/common';
import { ImportConsole } from 'src/import/console';
import { PrismaModule } from 'src/prisma';

@Module({
  imports: [PrismaModule],
  providers: [ImportConsole],
  exports: [],
  controllers: [],
})
export class ImportModule {}
