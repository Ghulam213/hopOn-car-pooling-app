/*
  Warnings:

  - Added the required column `carCategory` to the `RideFareFactors` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "CarCategory" AS ENUM ('ECONOMY', 'PREMIUM', 'LUXURY');

-- AlterTable
ALTER TABLE "RideFareFactors" ADD COLUMN     "carCategory" "CarCategory" NOT NULL;
