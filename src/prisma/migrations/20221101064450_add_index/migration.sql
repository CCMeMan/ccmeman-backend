-- CreateIndex
CREATE INDEX "Group_sUUID_idx" ON "Group"("sUUID");

-- CreateIndex
CREATE INDEX "Meeting_sUUID_idx" ON "Meeting"("sUUID");

-- CreateIndex
CREATE INDEX "User_userIdFromAuth0_idx" ON "User"("userIdFromAuth0");
