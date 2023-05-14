/*
  Warnings:

  - You are about to drop the `ExternalFactorsAffectingFare` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "RideRequestDemandEnum" AS ENUM ('LOW', 'MODERATE', 'HIGH');

-- CreateEnum
CREATE TYPE "RideAvailabilityEnum" AS ENUM ('LOW', 'MODERATE', 'HIGH');

-- DropTable
DROP TABLE "ExternalFactorsAffectingFare";

-- DropEnum
DROP TYPE "RideDemandEnum";

-- CreateTable
CREATE TABLE "RideFareFactors" (
    "id" TEXT NOT NULL,
    "petrolPricePerLitre" DOUBLE PRECISION NOT NULL,
    "weatherCondition" "WeatherConditionEnum" NOT NULL,
    "rideRequestDemand" "RideRequestDemandEnum" NOT NULL,
    "rideAvailability" "RideAvailabilityEnum" NOT NULL,
    "pricePerKm" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RideFareFactors_pkey" PRIMARY KEY ("id")
);
