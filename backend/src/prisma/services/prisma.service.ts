import { INestApplication, Injectable, OnModuleInit } from '@nestjs/common';
import { Prisma, PrismaClient, Ride } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
  constructor() {
    super({
      log: [
        { emit: 'event', level: 'query' },
        { emit: 'stdout', level: 'info' },
        { emit: 'stdout', level: 'warn' },
        { emit: 'stdout', level: 'error' },
      ],
      errorFormat: 'colorless',
    });
  }

  async onModuleInit() {
    await this.$connect();
  }

  async addMiddleware(cb: Prisma.Middleware) {
    this.$use(cb);
  }

  async enableShutdownHooks(app: INestApplication) {
    this.$on('beforeExit', async () => {
      await app.close();
    });
  }

  async enableDBQueryLoggingHooks() {
    this.$on<any>('query', (event: Prisma.QueryEvent) => {
      console.log({
        query: event.query,
        params: event.params,
        duration: event.duration,
      });
    });
  }
}
