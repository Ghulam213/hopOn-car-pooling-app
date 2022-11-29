import { registerAs } from '@nestjs/config';

export const applicationConfig = registerAs('application', () => ({
  databaseUrl: process.env.DATABASE_URL,
}));
