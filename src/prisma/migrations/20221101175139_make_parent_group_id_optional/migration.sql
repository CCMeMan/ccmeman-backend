-- DropForeignKey
ALTER TABLE "Group" DROP CONSTRAINT "Group_parentGroupId_fkey";

-- AlterTable
ALTER TABLE "Group" ALTER COLUMN "parentGroupId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Group" ADD CONSTRAINT "Group_parentGroupId_fkey" FOREIGN KEY ("parentGroupId") REFERENCES "Group"("id") ON DELETE SET NULL ON UPDATE CASCADE;
