import { Module } from '@nestjs/common';
import { PrismaService } from 'src/prisma/services';

@Module({
  imports: [],
  providers: [PrismaService],
  exports: [PrismaService],
})
export class PrismaModule {}
