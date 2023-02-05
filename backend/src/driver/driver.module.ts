import { Module } from '@nestjs/common';
import { DriverController } from 'src/driver/controllers/driver.controller';
import { DriverService } from 'src/driver/services';
import { LibraryModule } from 'src/library';
import { PrismaModule } from 'src/prisma';

@Module({
  imports: [LibraryModule, PrismaModule],
  providers: [DriverService],
  exports: [DriverService],
  controllers: [DriverController],
})
export class DriverModule {}
