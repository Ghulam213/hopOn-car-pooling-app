import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from 'src/app.controller';
import { applicationConfig, validationSchema } from 'src/config';
import { LibraryModule } from 'src/library';
import { PrismaService } from 'src/prisma.service';
import { UserModule } from 'src/user';

@Module({
  imports: [
    ConfigModule.forRoot({
      validationSchema,
      load: [applicationConfig],
      isGlobal: true,
    }),
    UserModule,
    LibraryModule,
  ],
  controllers: [AppController],
  providers: [PrismaService],
})
export class AppModule {}
