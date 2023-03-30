import { Module } from '@nestjs/common';
import { DriverModule } from 'src/driver';
import { LibraryModule } from 'src/library';
import { PrismaModule } from 'src/prisma';
import { UserModule } from 'src/user';

@Module({
  imports: [LibraryModule, PrismaModule, UserModule, DriverModule],
  providers: [],
  exports: [],
  controllers: [],
})
export class RideModule {}
