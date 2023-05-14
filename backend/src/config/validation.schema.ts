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
  PASSENGER_SOURCE_ON_ROUTE_THRESHOLD: Joi.number().default(3), // in km
  PASSENGER_DESTINATION_ON_ROUTE_THRESHOLD: Joi.number().default(3), // in km
  PASSENGER_DRIVER_DISTANCE_OVERLAP_THRESHOLD: Joi.number().default(4), // in km
  AWS_SNS_TOPIC_ARN_MARKETING: Joi.string().default('arn:aws:sns:us-east-1:146823716130:hopon-marketing.fifo'),
  AWS_SNS_PLATFORM_APPLICATION_ARN: Joi.string().default('arn:aws:sns:us-east-1:146823716130:app/GCM/hopon-client'),
  REDIS_SERVER_PORT: Joi.number().default(6379),
  REDIS_SERVER_URL: Joi.string().default('redis://localhost:6379'),
  REDIS_SERVER_HOSTNAME: Joi.string().default('localhost'),
  RIDE_CURRENT_LOCATION_CACHE_TTL: Joi.number().default(60 * 60 * 24), //24h
  RIDE_CURRENT_LOCATION_BASE_CACHE_KEY: Joi.string().default('ride_current_location'),
  FARE_BASE_FARE: Joi.number().default(50),
  FARE_PER_KM_FARE: Joi.number().default(10),
  ETA_PER_KM: Joi.number().default(2), // in minutes
  MAX_NUMBER_OF_PASSENGERS: Joi.number().default(4),
});
