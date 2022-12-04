-- CreateEnum
CREATE TYPE "CurrentModeEnum" AS ENUM ('DRIVER', 'PASSENGER');

-- CreateEnum
CREATE TYPE "GenderEnum" AS ENUM ('MALE', 'FEMALE');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "phone" TEXT,
    "locale" TEXT DEFAULT 'en',
    "timezone" TEXT,
    "currentCity" TEXT NOT NULL,
    "gender" "GenderEnum" NOT NULL,
    "birthDate" TIMESTAMP(3) NOT NULL,
    "profilePic" TEXT,
    "optedInAt" BOOLEAN NOT NULL DEFAULT false,
    "active" BOOLEAN NOT NULL DEFAULT false,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "currentMode" "CurrentModeEnum" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
