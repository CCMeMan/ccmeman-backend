import express from "express";
import { checkJwt } from "../auth.js";
import { PrismaClient, Role } from "@prisma/client";
import { nanoid } from "nanoid";

const router = express.Router();
const prisma = new PrismaClient();

router.use(checkJwt);
router.use(express.json());

// Create Meeting under Group: group_nanoid
router.post("/:group_nano_id", async (req, res) => {
  // Get Auth0 userID (i.e., sub) from JWT access token.
  const auth0UserID = req.auth.sub;
  console.log(
    "Create Meeting by POST api/meetings/:group_nanoid : " + auth0UserID
  );

  // Serch for the user in DB
  let db_user = await prisma.user.findUnique({
    where: { userIdFromAuth0: auth0UserID },
  });

  // If the corresponding db_user do not exist, send 403.
  if (!db_user) {
    res.status(403).send("Please Update User Profile First.");
    return;
  }

  // Get a Group by group_nano_id
  const group_nano_id = req.params.group_nano_id;
  const user_id = db_user.id;
  // console.log(user_id);

  const group = await prisma.group.findMany({
    where: {
      nanoId: group_nano_id,
      users: {
        some: {
          userId: user_id,
          role: { hasSome: [Role.MANAGER, Role.MEMBER] },
        }, // Check the User is MANAGER or MEMBER of this group.
      },
    },
  });

  const groupItem = group[0]; // Since we used findMany, we unwrap the returned array.

  if (!groupItem) {
    res.status(404).send("No such group.");
    return;
  }

  const group_id = groupItem.id;
  const meeting_nanoid = nanoid();
  const meeting_name = req.body.meeting_name;
  const meeting = await prisma.meeting.create({
    data: {
      nanoId: meeting_nanoid,
      name: meeting_name,
      groupId: group_id,
      users: {
        create: {
          user: {
            connect: { id: user_id },
          },
          role: Role.MANAGER,
        },
      },
    },
    include: {
      users: true,
    },
  });

  res.send(meeting);
});

// Get Meeting list under Group: group_nanoid
router.get("/:group_nano_id", async (req, res) => {
  // Get Auth0 userID (i.e., sub) from JWT access token.
  const auth0UserID = req.auth.sub;
  console.log(
    "Get Meeting list by GET api/meetings/:group_nanoid : " + auth0UserID
  );

  // Serch for the user in DB
  let db_user = await prisma.user.findUnique({
    where: { userIdFromAuth0: auth0UserID },
  });

  // If the corresponding db_user do not exist, send 403.
  if (!db_user) {
    res.status(403).send("Please Update User Profile First.");
    return;
  }

  // Get a Group by group_nano_id
  const group_nano_id = req.params.group_nano_id;
  const user_id = db_user.id;

  const group = await prisma.group.findMany({
    where: {
      nanoId: group_nano_id,
      users: {
        some: {
          userId: user_id,
          role: { hasSome: [Role.MANAGER, Role.MEMBER, Role.GUEST] },
        }, // Check if the User is MANAGER or MEMBER or GUEST of this group.
      },
    },
  });

  const groupItem = group[0]; // Since we used findMany, we unwrap the returned array.

  if (!groupItem) {
    res.status(404).send("No such group.");
    return;
  }

  const group_id = groupItem.id;
  const meetings = await prisma.meeting.findMany({
    where: {
      groupId: group_id,
      users: {
        some: {
          userId: user_id,
          role: { hasSome: [Role.MANAGER, Role.MEMBER, Role.GUEST] },
        }, // Check if the User is MANAGER or MEMBER or GUEST of this group.
      },
    },
    include: {
      users: {
        include: {
          user: {
            select: { name: true, userIdFromAuth0: true, email: true }, // TODO: maybe to include avatar img url
          },
        },
      },
    },
  });

  res.status(200).send(meetings);
});

// Get Meeting
// GET api/v1/meetings?meeting-nano-id=xxx
router.get("/", async (req, res) => {
  const auth0UserID = req.auth.sub;
  const meetingNanoId = req.query["meeting-nano-id"];
  console.log(
    "Get Meeting by GET api/meetings?meetingNanoId=" +
      meetingNanoId +
      " by " +
      auth0UserID
  );

  // Serch for the user in DB
  let db_user = await prisma.user.findUnique({
    where: { userIdFromAuth0: auth0UserID },
  });

  if (!db_user) {
    res.status(403).send("Please Update User Profile First.");
    return;
  }

  const user_id = db_user.id;

  // Find the meeting
  const meetings = await prisma.meeting.findMany({
    where: {
      nanoId: meetingNanoId,
      users: {
        some: {
          userId: user_id,
          role: { hasSome: [Role.MANAGER, Role.MEMBER, Role.GUEST] },
        }, // Check if the User is MANAGER or MEMBER or GUEST of this meeting.
      },
    },
    include: {
      users: {
        include: {
          user: {
            select: { name: true, userIdFromAuth0: true, email: true }, // TODO: maybe to include avatar img url
          },
        },
      },
      links: true,
    },
  });

  const meeting = meetings[0]; // Since we used findMany, we unwrap the returned array.
  if (!meeting) {
    res.status(404).send("No such meeting.");
    return;
  }

  res.status(200).send(meeting);
});

export default router;
