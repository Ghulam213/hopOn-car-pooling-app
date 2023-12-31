import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { createApp } from 'test/create-app';
import { AppModule } from './../src/app.module';

describe('AppController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    app = await createApp([AppModule]);
  });

  afterAll(async () => {
    await app.close();
  });

  it('/health (GET)', () => {
    return request(app.getHttpServer()).get('/health').expect(200).expect('{"data":"Hello World"}');
  });
});
