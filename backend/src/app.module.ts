import { Module } from '@nestjs/common';
import { ConfigModule, ConfigType } from '@nestjs/config';
import { S3, CognitoIdentityServiceProvider } from 'aws-sdk';
import { AwsSdkModule } from 'nest-aws-sdk';
import { AppController } from 'src/app.controller';
import { AuthModule } from 'src/auth';
import { applicationConfig, validationSchema } from 'src/config';
import { LibraryModule } from 'src/library';
import { PrismaModule } from 'src/prisma';
import { UserModule } from 'src/user';

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
      services: [S3, CognitoIdentityServiceProvider],
    }),
    PrismaModule,
    UserModule,
    AuthModule,
    LibraryModule,
  ],
  controllers: [AppController],
  providers: [],
})
export class AppModule {}
