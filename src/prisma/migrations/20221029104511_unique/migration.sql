/*
  Warnings:

  - A unique constraint covering the columns `[userIdFromAuth0]` on the table `User` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "User_userIdFromAuth0_key" ON "User"("userIdFromAuth0");
