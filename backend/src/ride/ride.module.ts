import { Module } from '@nestjs/common';
import { DriverModule } from 'src/driver';
import { LibraryModule } from 'src/library';
import { PassengerModule } from 'src/passenger';
import { PrismaModule } from 'src/prisma';
import { RideController } from 'src/ride/controllers';
import { RideService } from 'src/ride/services';
import { UserModule } from 'src/user';

@Module({
  imports: [LibraryModule, PrismaModule, UserModule, DriverModule, PassengerModule],
  providers: [RideService],
  exports: [RideService],
  controllers: [RideController],
})
export class RideModule {}
