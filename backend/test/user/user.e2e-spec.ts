import { INestApplication } from '@nestjs/common';
import * as path from 'path';
import { ImportService } from 'src/import/services';
import { UserModule } from 'src/user';
import * as request from 'supertest';
import { createApp } from 'test/create-app';

describe('User (e2e)', () => {
  let app: INestApplication;
  let importService: ImportService;

  beforeAll(async () => {
    app = await createApp([UserModule]);
    importService = app.get(ImportService);
    await importService.importEntities(path.resolve(__dirname, './fixtures'), true);
  });

  afterAll(async () => {
    await importService.flushAllEntities();
    await app.close();
  });

  it('Should get all users', async () => {
    const { body, statusCode } = await request(app.getHttpServer()).get('/users');
    expect(statusCode).toBe(200);
    expect(body).toBeDefined();
    expect(body.data.totalCount).toBe(2);
    expect(body.data.data.length).toBe(2);

    const dataWithUpdatedAndCreatedDates = body.data.data.map((user) => {
      const { createdAt, updatedAt, ...rest } = user;
      return rest;
    });

    expect(dataWithUpdatedAndCreatedDates).toEqual(
      expect.arrayContaining([
        {
          id: '5ee04f51-0692-48bb-bcbf-de3d88b90dd7',
          coginitoId: '3267e22b-115e-445f-adb1-2049d70d257f',
          email: 'user1@hopon.com',
          firstName: 'Ainne',
          lastName: 'Hales',
          phone: '+923360011224',
          locale: 'en',
          timezone: 'pk',
          currentCity: 'Islamabad',
          gender: 'FEMALE',
          birthDate: '2023-04-02T20:34:46.411Z',
          profilePic: '',
          optedInAt: true,
          active: true,
          verified: true,
          currentMode: 'PASSENGER',
        },
        {
          id: 'bd8c17df-5d49-4546-87ae-3073a7408f83',
          coginitoId: '8eab763d-f4f6-4910-a382-a2ebb0289b70',
          email: 'user2@hopon.com',
          firstName: 'John',
          lastName: 'Doe',
          phone: '+923360011225',
          locale: 'en',
          timezone: 'pk',
          currentCity: 'Islamabad',
          gender: 'MALE',
          birthDate: '2023-04-02T20:34:46.411Z',
          profilePic: '',
          optedInAt: true,
          active: true,
          verified: true,
          currentMode: 'DRIVER',
        },
      ]),
    );
  });

  it('Should get a user by Id', async () => {
    const { body, statusCode } = await request(app.getHttpServer()).get('/user/5ee04f51-0692-48bb-bcbf-de3d88b90dd7');
    expect(statusCode).toBe(200);
    expect(body).toBeDefined();
    expect(body.data).toBeDefined();
    const { createdAt, updatedAt, ...rest } = body.data;
    expect(rest).toEqual({
      id: '5ee04f51-0692-48bb-bcbf-de3d88b90dd7',
      coginitoId: '3267e22b-115e-445f-adb1-2049d70d257f',
      email: 'user1@hopon.com',
      firstName: 'Ainne',
      lastName: 'Hales',
      phone: '+923360011224',
      locale: 'en',
      timezone: 'pk',
      currentCity: 'Islamabad',
      gender: 'FEMALE',
      birthDate: '2023-04-02T20:34:46.411Z',
      profilePic: '',
      optedInAt: true,
      active: true,
      verified: true,
      currentMode: 'PASSENGER',
    });
  });

  it('Should get a user by email', async () => {
    const { body, statusCode } = await request(app.getHttpServer()).get('/user?email=user1@hopon.com');
    expect(statusCode).toBe(200);
    expect(body).toBeDefined();
    expect(body.data).toBeDefined();
    const { createdAt, updatedAt, ...rest } = body.data;
    expect(rest).toEqual({
      id: '5ee04f51-0692-48bb-bcbf-de3d88b90dd7',
      coginitoId: '3267e22b-115e-445f-adb1-2049d70d257f',
      email: 'user1@hopon.com',
      firstName: 'Ainne',
      lastName: 'Hales',
      phone: '+923360011224',
      locale: 'en',
      timezone: 'pk',
      currentCity: 'Islamabad',
      gender: 'FEMALE',
      birthDate: '2023-04-02T20:34:46.411Z',
      profilePic: '',
      optedInAt: true,
      active: true,
      verified: true,
      currentMode: 'PASSENGER',
    });
  });

  it('Should update a user', async () => {
    const { body, statusCode } = await request(app.getHttpServer())
      .put('/user/5ee04f51-0692-48bb-bcbf-de3d88b90dd7')
      .send({
        firstName: 'Ainne Changed',
        profilePic: 'https://www.google.com',
      });

    expect(statusCode).toBe(200);
    expect(body).toBeDefined();
    expect(body.data).toBeDefined();
    const { createdAt, updatedAt, ...rest } = body.data;

    expect(rest).toEqual({
      id: '5ee04f51-0692-48bb-bcbf-de3d88b90dd7',
      coginitoId: '3267e22b-115e-445f-adb1-2049d70d257f',
      email: 'user1@hopon.com',
      firstName: 'Ainne Changed',
      lastName: 'Hales',
      phone: '+923360011224',
      locale: 'en',
      timezone: 'pk',
      currentCity: 'Islamabad',
      gender: 'FEMALE',
      birthDate: '2023-04-02T20:34:46.411Z',
      profilePic: 'https://www.google.com',
      optedInAt: true,
      active: true,
      verified: true,
      currentMode: 'PASSENGER',
    });
  });

  it('Should delete a user', async () => {
    const { body, statusCode } = await request(app.getHttpServer()).delete(
      '/user/bd8c17df-5d49-4546-87ae-3073a7408f83',
    );
    expect(statusCode).toBe(200);
    expect(body).toBeDefined();
    expect(body.data).toBeDefined();

    const { body: getBody, statusCode: getStatusCode } = await request(app.getHttpServer()).get(
      '/user/bd8c17df-5d49-4546-87ae-3073a7408f83',
    );
    expect(getStatusCode).toBe(404);
    expect(getBody).toBeDefined();
    expect(getBody).toBeDefined();
    expect(getBody.error).toEqual('Not Found');
    expect(getBody.statusCode).toEqual(404);
    expect(getBody.message).toEqual(
      '{"message":"User with id bd8c17df-5d49-4546-87ae-3073a7408f83 not found","variables":{"id":"bd8c17df-5d49-4546-87ae-3073a7408f83"},"errorCode":"USER_NOT_FOUND"}',
    );
  });
});
