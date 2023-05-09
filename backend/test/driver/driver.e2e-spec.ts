import { INestApplication } from '@nestjs/common';
import * as path from 'path';
import * as request from 'supertest';
import { createApp } from 'test/create-app';
import { UserModule } from 'src/user';
import { ImportConsole } from 'src/import/console';
import { DriverModule } from 'src/driver';

describe('Driver (e2e)', () => {
  let app: INestApplication;
  let importConsole: ImportConsole;

  beforeAll(async () => {
    app = await createApp([UserModule, DriverModule]);
    importConsole = app.get(ImportConsole);
    await importConsole.importEntities(path.resolve(__dirname, './fixtures'), true);
  });

  afterAll(async () => {
    await importConsole.flushAllEntities();
    await app.close();
  });

  it('Should get all Drivers', async () => {
    const { body, statusCode } = await request(app.getHttpServer()).get('/drivers');
    expect(statusCode).toBe(200);
    expect(body).toBeDefined();
    expect(body.data.totalCount).toBe(2);
    expect(body.data.data.length).toBe(2);

    const dataWithoutUpdatedAndCreatedDates = body.data.data.map((drivers) => {
      const { createdAt, updatedAt, ...rest } = drivers;
      return rest;
    });

    expect(dataWithoutUpdatedAndCreatedDates).toEqual(
      expect.arrayContaining([
        {
          active: true,
          cnicBack: 'string',
          cnicFront: 'string',
          id: '83622820-35b4-40a9-bab1-618ba06c9881',
          licenseBack: 'string',
          licenseFront: 'string',
          userId: '56325284-dcf2-4d74-8f8e-60c245616cd0',
          verified: true,
        },
        {
          active: true,
          cnicBack: 'string',
          cnicFront: 'string',
          id: 'acc9ad42-5a21-428e-b1c3-bcff65df3491',
          licenseBack: 'string',
          licenseFront: 'string',
          userId: 'd829d645-cdc3-4238-96f4-ac6b17940e69',
          verified: true,
        },
      ]),
    );
  });

  it('Should get a driver by Id', async () => {
    const { body, statusCode } = await request(app.getHttpServer()).get('/driver/acc9ad42-5a21-428e-b1c3-bcff65df3491');
    expect(statusCode).toBe(200);
    expect(body).toBeDefined();
    expect(body.data).toBeDefined();
    const { createdAt, updatedAt, ...rest } = body.data;
    expect(rest).toEqual({
      active: true,
      cnicBack: 'string',
      cnicFront: 'string',
      id: 'acc9ad42-5a21-428e-b1c3-bcff65df3491',
      licenseBack: 'string',
      licenseFront: 'string',
      userId: 'd829d645-cdc3-4238-96f4-ac6b17940e69',
      verified: true,
    });
  });

  it('Should get a driver by user Id', async () => {
    const { body, statusCode } = await request(app.getHttpServer()).get(
      '/driver?userId=d829d645-cdc3-4238-96f4-ac6b17940e69',
    );
    expect(statusCode).toBe(200);
    expect(body).toBeDefined();
    expect(body.data).toBeDefined();
    const { createdAt, updatedAt, ...rest } = body.data;
    expect(rest).toEqual({
      active: true,
      cnicBack: 'string',
      cnicFront: 'string',
      id: 'acc9ad42-5a21-428e-b1c3-bcff65df3491',
      licenseBack: 'string',
      licenseFront: 'string',
      userId: 'd829d645-cdc3-4238-96f4-ac6b17940e69',
      verified: true,
    });
  });

  it('Should create a driver', async () => {
    const { body, statusCode } = await request(app.getHttpServer())
      .post('/driver')
      .send({
        active: true,
        cnicFront: 'Some string',
        cnicBack: 'Some string',
        licenseBack: 'string',
        licenseFront: 'string',
        userId: '98c0f284-8e17-4c8b-9fd5-5b98056dce6f',
        verified: true,
        vehicle: {
          vehicleType: 'CAR',
          vehicleBrand: 'Toyota',
          vehicleModel: 'Corolla',
          vehicleColor: 'White',
          vehiclePhoto: 'string',
          vehicleRegImage: 'string',
          vehicleRegNo: 'string',
        },
      });

    console.log(body);
    expect(statusCode).toBe(200);
    expect(body).toBeDefined();
    expect(body.data).toBeDefined();
    const { createdAt, updatedAt, id, ...rest } = body.data;

    expect(id).toBeDefined();
    expect(rest).toEqual({
      active: true,
      cnicFront: 'Some string',
      cnicBack: 'Some string',
      licenseBack: 'string',
      licenseFront: 'string',
      userId: '98c0f284-8e17-4c8b-9fd5-5b98056dce6f',
      verified: true,
      vehicle: [
        {
          vehicleType: 'CAR',
          vehicleBrand: 'Toyota',
          vehicleModel: 'Corolla',
          vehicleColor: 'White',
          vehiclePhoto: 'string',
          vehicleRegImage: 'string',
          vehicleRegNo: 'string',
        },
      ],
    });
  });

  it('Should update a driver', async () => {
    const { body, statusCode } = await request(app.getHttpServer())
      .put('/driver/acc9ad42-5a21-428e-b1c3-bcff65df3491')
      .send({
        cnicFront: 'Some string',
        cnicBack: 'Some string',
      });

    expect(statusCode).toBe(200);
    expect(body).toBeDefined();
    expect(body.data).toBeDefined();
    const { createdAt, updatedAt, ...rest } = body.data;

    expect(rest).toEqual({
      active: true,
      cnicFront: 'Some string',
      cnicBack: 'Some string',
      id: 'acc9ad42-5a21-428e-b1c3-bcff65df3491',
      licenseBack: 'string',
      licenseFront: 'string',
      userId: 'd829d645-cdc3-4238-96f4-ac6b17940e69',
      verified: true,
    });
  });

  it('Should delete a driver', async () => {
    const { body, statusCode } = await request(app.getHttpServer()).delete(
      '/driver/83622820-35b4-40a9-bab1-618ba06c9881',
    );
    expect(statusCode).toBe(200);
    expect(body).toBeDefined();
    expect(body.data).toBeDefined();

    const { body: getBody, statusCode: getStatusCode } = await request(app.getHttpServer()).get(
      '/driver/83622820-35b4-40a9-bab1-618ba06c9881',
    );
    expect(getStatusCode).toBe(404);
    expect(getBody).toBeDefined();
    expect(getBody).toBeDefined();
    expect(getBody.error).toEqual('Not Found');
    expect(getBody.statusCode).toEqual(404);
    expect(getBody.message).toEqual(
      '{"message":"Driver with id 83622820-35b4-40a9-bab1-618ba06c9881 or userId  not found","variables":{"id":"83622820-35b4-40a9-bab1-618ba06c9881"},"errorCode":"DRIVER_NOT_FOUND"}',
    );
  });
});
