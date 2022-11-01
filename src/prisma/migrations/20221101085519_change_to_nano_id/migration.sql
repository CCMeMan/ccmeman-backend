/*
  Warnings:

  - You are about to drop the column `sUUID` on the `Group` table. All the data in the column will be lost.
  - You are about to drop the column `sUUID` on the `Meeting` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[nanoId]` on the table `Group` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[nanoId]` on the table `Meeting` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `nanoId` to the `Group` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nanoId` to the `Meeting` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "Group_sUUID_idx";

-- DropIndex
DROP INDEX "Group_sUUID_key";

-- DropIndex
DROP INDEX "Meeting_sUUID_idx";

-- DropIndex
DROP INDEX "Meeting_sUUID_key";

-- AlterTable
ALTER TABLE "Group" DROP COLUMN "sUUID",
ADD COLUMN     "nanoId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Meeting" DROP COLUMN "sUUID",
ADD COLUMN     "nanoId" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Group_nanoId_key" ON "Group"("nanoId");

-- CreateIndex
CREATE INDEX "Group_nanoId_idx" ON "Group"("nanoId");

-- CreateIndex
CREATE UNIQUE INDEX "Meeting_nanoId_key" ON "Meeting"("nanoId");

-- CreateIndex
CREATE INDEX "Meeting_nanoId_idx" ON "Meeting"("nanoId");
