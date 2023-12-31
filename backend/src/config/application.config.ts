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
  imageUploadBucket: process.env.IMAGE_UPLOAD_BUCKET,
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
  },
  passengerSourceOnRouteThreshold: parseFloat(process.env.PASSENGER_SOURCE_ON_ROUTE_THRESHOLD),
  passengerDestinationOnRouteThreshold: parseFloat(process.env.PASSENGER_DESTINATION_ON_ROUTE_THRESHOLD),
  passengerDriverDistanceOverlapThreshold: parseFloat(process.env.PASSENGER_DRIVER_DISTANCE_OVERLAP_THRESHOLD),
  awsSnsTopicType: {
    marketing: process.env.AWS_SNS_TOPIC_ARN_RIDE_REQUEST,
  },
  awsSnsPlatformApplicationArn: process.env.AWS_SNS_PLATFORM_APPLICATION_ARN,
  redisServerPort: process.env.REDIS_SERVER_PORT,
  redisServerUrl: process.env.REDIS_SERVER_URL,
  redisServerHostname: process.env.REDIS_SERVER_HOSTNAME,
  rideCurrentLocationCache: {
    ttl: parseInt(process.env.RIDE_CURRENT_LOCATION_CACHE_TTL, 10),
    baseCacheKey: process.env.RIDE_CURRENT_LOCATION_BASE_CACHE_KEY,
  },
  fare: {
    baseFare: parseFloat(process.env.FARE_BASE_FARE),
    perKmFare: parseFloat(process.env.FARE_PER_KM_FARE),
  },
  etaPerKm: parseFloat(process.env.ETA_PER_KM),
  maxNumberOfPassengers: parseInt(process.env.MAX_NUMBER_OF_PASSENGERS, 10),
}));
