import { Module } from '@nestjs/common';
import { LibraryModule } from 'src/library';
import { PrismaModule } from 'src/prisma';
import { UserController } from 'src/user/controllers';
import { UserService } from 'src/user/services';

@Module({
  imports: [LibraryModule, PrismaModule],
  providers: [UserService],
  exports: [UserService],
  controllers: [UserController],
})
export class UserModule {}
