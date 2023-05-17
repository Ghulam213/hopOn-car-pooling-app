import { CacheModule } from '@nestjs/cache-manager';
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigType } from '@nestjs/config';
import { RedisClientOptions } from 'redis';
import { applicationConfig } from 'src/config';
import { FileController } from 'src/library/controllers';
import { ParseUUIDStringPipe } from 'src/library/pipes';
import { FileService, UtilityService } from 'src/library/services';
import { NotificationService } from 'src/library/services/notification.service';

const redisStore = require('cache-manager-redis-store').redisStore;

@Module({
  imports: [
    CacheModule.registerAsync<RedisClientOptions>({
      useFactory: (appConfig: ConfigType<typeof applicationConfig>) => {
        return {
          isGlobal: true,
          store: redisStore,
          url: appConfig.redisServerUrl,
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
