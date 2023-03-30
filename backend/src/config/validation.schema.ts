import * as Joi from 'joi';

export const validationSchema = Joi.object({
  DATABASE_URL: Joi.string().uri().default('postgresql://hopon:hopon@localhost:5432/hopon_dev?schema=public'),
  AWS_REGION: Joi.string().default('us-east-1'),
  AWS_ACCESS_KEY_ID: Joi.string().default(''),
  AWS_SECRET_ACCESS_KEY: Joi.string().default(''),
  AWS_SESSION_TOKEN: Joi.string().default(''),
  COGNITO_CLIENT_ID: Joi.string().default('1m3ffti43gmbmc7obtgge17rfq'),
  COGNITO_USER_POOL_ID: Joi.string().default('us-east-1_1zYhKedOW'),
  JWT_SECRET: Joi.string().default('CHANGE_ME'),
  JWT_TTL: Joi.number().default(60 * 60), //1h
  JWT_REFRESH_SECRET: Joi.string().default('CHANGE_ME_REFRESH'),
  JWT_REFRESH_TTL: Joi.number().default(60 * 60 * 24), //1d
  API_KEY_SECRET: Joi.string().default('CHANGE_ME_API_KEY'),
  IMAGE_UPLOAD_BUCKET: Joi.string().default('hopon-image-uploads'),
  DESTINATION_OVERLAP_THRESHOLD: Joi.number().default(0.5), // in km
  PASSENGER_DRIVER_DISTANCE_OVERLAP_THRESHOLD: Joi.number().default(0.3), // in km
  ROUTE_OVERLAP_THRESHOLD: Joi.number().default(0.3), // in km
  AWS_SNS_TOPIC_ARN_RIDE_REQUEST: Joi.string().default('hopon-ride-request'),
});
