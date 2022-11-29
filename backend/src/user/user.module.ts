import { Module } from '@nestjs/common';
import { LibraryModule } from 'src/library';
import { PrismaService } from 'src/prisma.service';
import { UserController } from 'src/user/controllers';
import { UserService } from 'src/user/services';

@Module({
  imports: [LibraryModule],
  providers: [UserService, PrismaService],
  exports: [UserService],
  controllers: [UserController],
})
export class UserModule {}
