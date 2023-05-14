import { Module } from '@nestjs/common';
import { ConfigModule, ConfigType } from '@nestjs/config';
import { CognitoIdentityServiceProvider, S3, SNS } from 'aws-sdk';
import { AwsSdkModule } from 'nest-aws-sdk';
import { ConsoleModule } from 'nestjs-console';
import { AppController } from 'src/app.controller';
import { AuthModule } from 'src/auth';
import { applicationConfig, validationSchema } from 'src/config';
import { DriverModule } from 'src/driver';
import { ImportModule } from 'src/import';
import { LibraryModule } from 'src/library';
import { PassengerModule } from 'src/passenger';
import { PrismaModule } from 'src/prisma';
import { RideModule } from 'src/ride';
import { UserModule } from 'src/user';

const redisStore = require('cache-manager-redis-store').redisStore;
@Module({
  imports: [
    ConfigModule.forRoot({
      validationSchema,
      load: [applicationConfig],
      isGlobal: true,
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
      services: [S3, CognitoIdentityServiceProvider, SNS],
    }),
    ConsoleModule,
    ImportModule,
    PrismaModule,
    UserModule,
    AuthModule,
    LibraryModule,
    DriverModule,
    PassengerModule,
    RideModule,
  ],
  controllers: [AppController],
  providers: [],
})
export class AppModule {}
