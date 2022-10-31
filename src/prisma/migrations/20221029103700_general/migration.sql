/*
  Warnings:

  - The primary key for the `Meeting` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Meeting` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `UsersOnMeetings` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - Added the required column `userIdFromAuth0` to the `User` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `meetingId` on the `UsersOnMeetings` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `userId` on the `UsersOnMeetings` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- DropForeignKey
ALTER TABLE "UsersOnMeetings" DROP CONSTRAINT "UsersOnMeetings_meetingId_fkey";

-- DropForeignKey
ALTER TABLE "UsersOnMeetings" DROP CONSTRAINT "UsersOnMeetings_userId_fkey";

-- AlterTable
ALTER TABLE "Meeting" DROP CONSTRAINT "Meeting_pkey",
ADD COLUMN     "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "info" TEXT,
ADD COLUMN     "name" TEXT,
ADD COLUMN     "roomURL" TEXT,
ADD COLUMN     "time" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "Meeting_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "User" DROP CONSTRAINT "User_pkey",
ADD COLUMN     "userIdFromAuth0" TEXT NOT NULL,
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ALTER COLUMN "name" DROP NOT NULL,
ALTER COLUMN "email" DROP NOT NULL,
ALTER COLUMN "systemRole" SET DEFAULT 'USER',
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "UsersOnMeetings" DROP CONSTRAINT "UsersOnMeetings_pkey",
DROP COLUMN "meetingId",
ADD COLUMN     "meetingId" INTEGER NOT NULL,
DROP COLUMN "userId",
ADD COLUMN     "userId" INTEGER NOT NULL,
ADD CONSTRAINT "UsersOnMeetings_pkey" PRIMARY KEY ("meetingId", "userId");

-- CreateTable
CREATE TABLE "Group" (
    "id" SERIAL NOT NULL,

    CONSTRAINT "Group_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UsersOnGroups" (
    "groupId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "role" "Role"[] DEFAULT ARRAY['GUEST']::"Role"[],

    CONSTRAINT "UsersOnGroups_pkey" PRIMARY KEY ("groupId","userId")
);

-- CreateTable
CREATE TABLE "Link" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "meetingId" INTEGER NOT NULL,
    "name" TEXT,
    "URL" TEXT,

    CONSTRAINT "Link_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "UsersOnGroups" ADD CONSTRAINT "UsersOnGroups_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsersOnGroups" ADD CONSTRAINT "UsersOnGroups_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsersOnMeetings" ADD CONSTRAINT "UsersOnMeetings_meetingId_fkey" FOREIGN KEY ("meetingId") REFERENCES "Meeting"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsersOnMeetings" ADD CONSTRAINT "UsersOnMeetings_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_meetingId_fkey" FOREIGN KEY ("meetingId") REFERENCES "Meeting"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
