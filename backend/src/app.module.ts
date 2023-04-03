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
const redisStore = require('cache-manager-redis-store').redisStore as CacheStore;
import { RideModule } from 'src/ride';
import { ConsoleModule } from 'nestjs-console';
import { ImportModule } from 'src/import';

@Module({
  imports: [
    ConfigModule.forRoot({
      validationSchema,
      load: [applicationConfig],
      isGlobal: true,
    }),
    CacheModule.registerAsync({
      useFactory: (appConfig: ConfigType<typeof applicationConfig>) => {
        return {
          isGlobal: true,
          store: redisStore,
          host: appConfig.redisServerHostname,
          port: appConfig.redisServerPort,
        };
      },
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
    ConsoleModule,
    ImportModule,
    PrismaModule,
    UserModule,
    AuthModule,
    LibraryModule,
    DriverModule,
    RideModule,
  ],
  controllers: [AppController],
  providers: [],
})
export class AppModule {}
