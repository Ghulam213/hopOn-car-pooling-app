import { Module } from '@nestjs/common';
import { LibraryModule } from 'src/library';
import { PassengerController } from 'src/passenger/controllers';
import { PassengerService } from 'src/passenger/services';
import { PrismaModule } from 'src/prisma';

@Module({
  imports: [LibraryModule, PrismaModule],
  providers: [PassengerService],
  exports: [PassengerService],
  controllers: [PassengerController],
})
export class PassengerModule {}
