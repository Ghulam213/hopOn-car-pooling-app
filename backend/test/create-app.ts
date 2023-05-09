import { INestApplication, ValidationPipe } from '@nestjs/common';
import { Type } from '@nestjs/common/interfaces/type.interface';
import { ConfigModule, ConfigService, ConfigType } from '@nestjs/config';
import { Test, TestingModule } from '@nestjs/testing';
import { CognitoIdentityServiceProvider, S3, SNS } from 'aws-sdk';
import { useContainer } from 'class-validator';
import { AwsSdkModule } from 'nest-aws-sdk';
import { ConsoleModule } from 'nestjs-console';
import { resolve } from 'path';
import { AppController } from 'src/app.controller';
import { applicationConfig, validationSchema } from 'src/config';
import { ImportModule } from 'src/import';
import { LibraryModule } from 'src/library';
import { ResponseMappingInterceptor } from 'src/library/interceptors';
import { PrismaModule } from 'src/prisma';

export function initModule(modules: Array<Type<any>> = []): Promise<TestingModule> {
  const testModule = Test.createTestingModule({
    imports: [
      ...modules,
      ConfigModule.forRoot({
        validationSchema,
        load: [applicationConfig],
        envFilePath: resolve(__dirname, '../.env.test'),
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
      LibraryModule,
    ],
    controllers: [AppController],
    providers: [],
  });

  return testModule.compile();
}

export const createApp = async (modules: Array<Type<any>> = []): Promise<INestApplication> => {
  const moduleFixture: TestingModule = await initModule(modules);
  const app = moduleFixture.createNestApplication();
  useContainer(app, { fallbackOnErrors: true });
  const configService = app.get(ConfigService);
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
  app.useGlobalInterceptors(new ResponseMappingInterceptor());
  await app.init();
  return app;
};
