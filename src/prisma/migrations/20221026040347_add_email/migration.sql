/*
  Warnings:

  - Added the required column `systemRole` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Role" AS ENUM ('MANAGER', 'MEMBER', 'GUEST');

-- CreateEnum
CREATE TYPE "SystemRole" AS ENUM ('USER', 'ADMIN');

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "systemRole" "SystemRole" NOT NULL;

-- CreateTable
CREATE TABLE "Meeting" (
    "id" TEXT NOT NULL,

    CONSTRAINT "Meeting_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UsersOnMeetings" (
    "meetingId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "role" "Role"[] DEFAULT ARRAY['GUEST']::"Role"[],
    "publicEmail" TEXT NOT NULL,

    CONSTRAINT "UsersOnMeetings_pkey" PRIMARY KEY ("meetingId","userId")
);

-- AddForeignKey
ALTER TABLE "UsersOnMeetings" ADD CONSTRAINT "UsersOnMeetings_meetingId_fkey" FOREIGN KEY ("meetingId") REFERENCES "Meeting"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsersOnMeetings" ADD CONSTRAINT "UsersOnMeetings_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
