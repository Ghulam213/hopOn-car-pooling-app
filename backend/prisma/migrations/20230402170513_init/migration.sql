/*
  Warnings:

  - The values [REQUESTED,ACCEPTED,REJECTED] on the enum `RideStatusEnum` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "RideStatusEnum_new" AS ENUM ('ON_GOING', 'COMPLETED', 'CANCELLED');
ALTER TABLE "Ride" ALTER COLUMN "rideStatus" TYPE "RideStatusEnum_new" USING ("rideStatus"::text::"RideStatusEnum_new");
ALTER TYPE "RideStatusEnum" RENAME TO "RideStatusEnum_old";
ALTER TYPE "RideStatusEnum_new" RENAME TO "RideStatusEnum";
DROP TYPE "RideStatusEnum_old";
COMMIT;
