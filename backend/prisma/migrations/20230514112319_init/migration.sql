-- CreateTable
CREATE TABLE "PassengerRidePreferences" (
    "id" TEXT NOT NULL,
    "passengerId" TEXT NOT NULL,
    "genderPreference" "GenderEnum" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PassengerRidePreferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DriverRidePreferences" (
    "id" TEXT NOT NULL,
    "driverId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "genderPreference" "GenderEnum" NOT NULL,
    "maxNumberOfPassengers" INTEGER NOT NULL,

    CONSTRAINT "DriverRidePreferences_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "PassengerRidePreferences" ADD CONSTRAINT "PassengerRidePreferences_passengerId_fkey" FOREIGN KEY ("passengerId") REFERENCES "Passenger"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DriverRidePreferences" ADD CONSTRAINT "DriverRidePreferences_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "Driver"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
