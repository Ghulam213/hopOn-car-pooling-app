-- DropForeignKey
ALTER TABLE "Ride" DROP CONSTRAINT "Ride_passengerId_fkey";

-- AlterTable
ALTER TABLE "Ride" ALTER COLUMN "passengerId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Ride" ADD CONSTRAINT "Ride_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger"("id") ON DELETE SET NULL ON UPDATE CASCADE;
