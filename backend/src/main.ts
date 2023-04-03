import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, SwaggerDocumentOptions, DocumentBuilder } from '@nestjs/swagger';
import { NestFactory } from '@nestjs/core';
import { PrismaService } from 'src/prisma/services/prisma.service';
import { AppModule } from 'src/app.module';
import { ResponseMappingInterceptor } from 'src/library/interceptors';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
  app.useGlobalInterceptors(new ResponseMappingInterceptor());

  const prismaService = app.get(PrismaService);
  await prismaService.enableShutdownHooks(app);
  // await prismaService.enableDBQueryLoggingHooks();

  const config = new DocumentBuilder()
    .setTitle('Hop On API')
    .setDescription('The Hop On API description')
    .setVersion('0.1')
    .build();

  const options: SwaggerDocumentOptions = {
    operationIdFactory: (_: string, methodKey: string) => methodKey,
  };

  const document = SwaggerModule.createDocument(app, config, options);
  SwaggerModule.setup('/doc/api', app, document);

  app.enableCors({ origin: true });
  await app.listen(3001);
  console.log(`Application is running on: ${await app.getUrl()}`);
}
bootstrap();
