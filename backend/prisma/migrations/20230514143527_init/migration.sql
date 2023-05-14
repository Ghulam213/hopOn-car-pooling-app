/*
  Warnings:

  - A unique constraint covering the columns `[driverId]` on the table `DriverRidePreferences` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[passengerId]` on the table `PassengerRidePreferences` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "DriverRidePreferences_driverId_key" ON "DriverRidePreferences"("driverId");

-- CreateIndex
CREATE UNIQUE INDEX "PassengerRidePreferences_passengerId_key" ON "PassengerRidePreferences"("passengerId");
