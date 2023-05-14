/*
  Warnings:

  - You are about to drop the column `carCategory` on the `RideFareFactors` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "RideFareFactors" DROP COLUMN "carCategory";

-- DropEnum
DROP TYPE "CarCategory";
