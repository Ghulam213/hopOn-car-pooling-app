/*
  Warnings:

  - You are about to drop the column `passengerId` on the `Ride` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Ride" DROP CONSTRAINT "Ride_passengerId_fkey";

-- AlterTable
ALTER TABLE "Ride" DROP COLUMN "passengerId";
