-- CreateEnum
CREATE TYPE "Role" AS ENUM ('MANAGER', 'MEMBER', 'GUEST');

-- CreateEnum
CREATE TYPE "SystemRole" AS ENUM ('USER', 'ADMIN');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "userIdFromAuth0" TEXT NOT NULL,
    "name" TEXT,
    "email" TEXT,
    "systemRole" "SystemRole" NOT NULL DEFAULT 'USER',

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Group" (
    "id" SERIAL NOT NULL,
    "nanoId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "parentGroupId" INTEGER NOT NULL,

    CONSTRAINT "Group_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UsersOnGroups" (
    "groupId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "role" "Role"[] DEFAULT ARRAY['GUEST']::"Role"[],
    "publicEmail" TEXT NOT NULL,

    CONSTRAINT "UsersOnGroups_pkey" PRIMARY KEY ("groupId","userId")
);

-- CreateTable
CREATE TABLE "Meeting" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "nanoId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "groupId" INTEGER NOT NULL,
    "time" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "roomURL" TEXT,
    "location" TEXT,
    "info" TEXT,

    CONSTRAINT "Meeting_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UsersOnMeetings" (
    "meetingId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "role" "Role"[] DEFAULT ARRAY['GUEST']::"Role"[],

    CONSTRAINT "UsersOnMeetings_pkey" PRIMARY KEY ("meetingId","userId")
);

-- CreateTable
CREATE TABLE "Link" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "meetingId" INTEGER NOT NULL,
    "name" TEXT,
    "URL" TEXT,

    CONSTRAINT "Link_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_userIdFromAuth0_key" ON "User"("userIdFromAuth0");

-- CreateIndex
CREATE INDEX "User_userIdFromAuth0_idx" ON "User"("userIdFromAuth0");

-- CreateIndex
CREATE UNIQUE INDEX "Group_nanoId_key" ON "Group"("nanoId");

-- CreateIndex
CREATE INDEX "Group_nanoId_idx" ON "Group"("nanoId");

-- CreateIndex
CREATE UNIQUE INDEX "Meeting_nanoId_key" ON "Meeting"("nanoId");

-- CreateIndex
CREATE INDEX "Meeting_nanoId_idx" ON "Meeting"("nanoId");

-- AddForeignKey
ALTER TABLE "Group" ADD CONSTRAINT "Group_parentGroupId_fkey" FOREIGN KEY ("parentGroupId") REFERENCES "Group"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsersOnGroups" ADD CONSTRAINT "UsersOnGroups_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsersOnGroups" ADD CONSTRAINT "UsersOnGroups_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Meeting" ADD CONSTRAINT "Meeting_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsersOnMeetings" ADD CONSTRAINT "UsersOnMeetings_meetingId_fkey" FOREIGN KEY ("meetingId") REFERENCES "Meeting"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsersOnMeetings" ADD CONSTRAINT "UsersOnMeetings_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Link" ADD CONSTRAINT "Link_meetingId_fkey" FOREIGN KEY ("meetingId") REFERENCES "Meeting"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
