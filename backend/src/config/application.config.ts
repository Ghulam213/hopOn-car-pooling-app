import { registerAs } from '@nestjs/config';

export const applicationConfig = registerAs('application', () => ({
  databaseUrl: process.env.DATABASE_URL,
  environment: process.env.NODE_ENV,
  awsRegion: process.env.AWS_REGION,
  awsAccessKeyId: process.env.AWS_ACCESS_KEY_ID,
  awsSecretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  awsSessionToken: process.env.AWS_SESSION_TOKEN,
  cognitoClientId: process.env.COGNITO_CLIENT_ID,
  cognitoUserPoolId: process.env.COGNITO_USER_POOL_ID,
  jwt: {
    access: {
      secret: process.env.JWT_SECRET,
      expiresIn: parseInt(process.env.JWT_TTL, 10),
    },
    refresh: {
      secret: process.env.JWT_REFRESH_SECRET,
      expiresIn: parseInt(process.env.JWT_REFRESH_TTL, 10),
    },
  },
  apiKey: {
    secret: process.env.API_KEY_SECRET,
  }
}));
