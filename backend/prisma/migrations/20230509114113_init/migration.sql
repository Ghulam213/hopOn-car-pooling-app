-- CreateEnum
CREATE TYPE "WeatherConditionEnum" AS ENUM ('SUNNY', 'RAINY', 'CLOUDY');

-- CreateEnum
CREATE TYPE "RideDemandEnum" AS ENUM ('LOW', 'MODERATE', 'HIGH');

-- CreateTable
CREATE TABLE "ExternalFactorsAffectingFare" (
    "id" TEXT NOT NULL,
    "petrolPricePerLitre" DOUBLE PRECISION NOT NULL,
    "weatherCondition" "WeatherConditionEnum" NOT NULL,
    "rideDemand" "RideDemandEnum" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ExternalFactorsAffectingFare_pkey" PRIMARY KEY ("id")
);
