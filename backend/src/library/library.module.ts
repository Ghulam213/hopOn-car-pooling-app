import { CacheModule, Module } from '@nestjs/common';
import { ConfigModule, ConfigType } from '@nestjs/config';
import { applicationConfig } from 'src/config';
import { FileController } from 'src/library/controllers';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { FileService, UtilityService } from 'src/library/services';
import { NotificationService } from 'src/library/services/notification.service';

const redisStore = require('cache-manager-redis-store').redisStore;

@Module({
  imports: [
    CacheModule.registerAsync({
      useFactory: (appConfig: ConfigType<typeof applicationConfig>) => {
        return {
          isGlobal: true,
          store: redisStore,
          host: appConfig.redisServerHostname,
          port: appConfig.redisServerPort,
        };
      },
      imports: [ConfigModule],
      inject: [applicationConfig.KEY],
    }),
  ],
  providers: [UtilityService, ParseUUIDStringPipe, FileService, NotificationService],
  exports: [UtilityService, FileService, NotificationService, CacheModule],
  controllers: [FileController],
})
export class LibraryModule {}
