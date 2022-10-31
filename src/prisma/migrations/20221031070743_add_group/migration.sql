/*
  Warnings:

  - A unique constraint covering the columns `[sUUID]` on the table `Group` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[sUUID]` on the table `Meeting` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `name` to the `Group` table without a default value. This is not possible if the table is not empty.
  - Added the required column `sUUID` to the `Group` table without a default value. This is not possible if the table is not empty.
  - Added the required column `groupId` to the `Meeting` table without a default value. This is not possible if the table is not empty.
  - Added the required column `sUUID` to the `Meeting` table without a default value. This is not possible if the table is not empty.
  - Made the column `name` on table `Meeting` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "Group" ADD COLUMN     "name" TEXT NOT NULL,
ADD COLUMN     "sUUID" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Link" ALTER COLUMN "createdAt" SET DATA TYPE TIMESTAMP(3);

-- AlterTable
ALTER TABLE "Meeting" ADD COLUMN     "groupId" INTEGER NOT NULL,
ADD COLUMN     "sUUID" TEXT NOT NULL,
ALTER COLUMN "createdAt" SET DATA TYPE TIMESTAMP(3),
ALTER COLUMN "name" SET NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Group_sUUID_key" ON "Group"("sUUID");

-- CreateIndex
CREATE UNIQUE INDEX "Meeting_sUUID_key" ON "Meeting"("sUUID");

-- AddForeignKey
ALTER TABLE "Meeting" ADD CONSTRAINT "Meeting_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
