import { Module, CacheModule, CacheStore } from '@nestjs/common';
import { ConfigModule, ConfigType } from '@nestjs/config';
import { S3, CognitoIdentityServiceProvider } from 'aws-sdk';
import { AwsSdkModule } from 'nest-aws-sdk';
import { AppController } from 'src/app.controller';
import { AuthModule } from 'src/auth';
import { applicationConfig, validationSchema } from 'src/config';
import { LibraryModule } from 'src/library';
import { PrismaModule } from 'src/prisma';
import { UserModule } from 'src/user';
import { DriverModule } from 'src/driver';
import type { RedisClientOptions } from 'redis';
const redisStore = require('cache-manager-redis-store').redisStore as CacheStore;

@Module({
  imports: [
    ConfigModule.forRoot({
      validationSchema,
      load: [applicationConfig],
      isGlobal: true,
    }),
    CacheModule.register<RedisClientOptions>({
      isGlobal: true,
      store: redisStore,
    }),
    AwsSdkModule.forRootAsync({
      defaultServiceOptions: {
        useFactory: (appConfig: ConfigType<typeof applicationConfig>) => {
          return {
            region: appConfig.awsRegion,
            credentials: {
              accessKeyId: appConfig.awsAccessKeyId,
              secretAccessKey: appConfig.awsSecretAccessKey,
              sessionToken: appConfig.awsSessionToken,
            },
          };
        },
        imports: [ConfigModule],
        inject: [applicationConfig.KEY],
      },
      services: [S3, CognitoIdentityServiceProvider],
    }),
    PrismaModule,
    UserModule,
    AuthModule,
    LibraryModule,
    DriverModule,
  ],
  controllers: [AppController],
  providers: [],
})
export class AppModule {}
