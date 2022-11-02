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
  console.log("Create Group by POST api/groups/: " + auth0UserID);

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

  // const group = await prisma.group.findMany({
  //   where: {
  //     nanoId: group_nano_id,
  //     users: {
  //       some: {
  //         userId: user_id,
  //         OR: [{ role: Role.MANAGER }, { role: Role.MEMBER }],
  //       }, // Check the User is MANAGER or MEMBER of this group.
  //     },
  //   },
  // });

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

// // Get a list of Groups of a User
// router.get("/", async (req, res) => {
//   // Get Auth0 userID (i.e., sub) from JWT access token.
//   const auth0UserID = req.auth.sub;
//   console.log("Get Group by GET api/groups/: " + auth0UserID);

//   // Serch for the user in DB
//   let db_user = await prisma.user.findUnique({
//     where: { userIdFromAuth0: auth0UserID },
//   });

//   // If the corresponding db_user do not exist, send 403.
//   if (!db_user) {
//     res.status(403).send("Please Update User Profile First.");
//     return;
//   }

//   const user_id = db_user.id;
//   console.log(user_id);
//   // const groups = await prisma.user.findUnique({
//   //   where: { userIdFromAuth0: auth0UserID },
//   //   select: {
//   //     groups: {
//   //       include: {
//   //         user: true,
//   //       },
//   //     },
//   //   },
//   // });

//   const groups = await prisma.group.findMany({
//     where: { users: { some: { userId: user_id } } },
//     include: {
//       users: {
//         include: { user: true },
//       },
//     },
//   });

//   // const group = await prisma.group.create({
//   //   data: {
//   //     sUUID: group_suuid,
//   //     name: group_name,
//   //     users: {
//   //       create: {
//   //         user: {
//   //           connect: { id: user_id },
//   //         },
//   //         role: Role.MANAGER,
//   //       },
//   //     },
//   //   },
//   //   include: {
//   //     users: true,
//   //   },
//   // });

//   res.send(groups);
// });

// // Get a Group by group_nano_id
// router.get("/:group_nano_id", async (req, res) => {
//   // Get Auth0 userID (i.e., sub) from JWT access token.
//   const group_nano_id = req.params.group_nano_id;
//   const auth0UserID = req.auth.sub;
//   console.log("Get Group by GET api/groups/group_nano_id : " + auth0UserID);

//   // Serch for the user in DB
//   let db_user = await prisma.user.findUnique({
//     where: { userIdFromAuth0: auth0UserID },
//   });

//   // If the corresponding db_user do not exist, send 403.
//   if (!db_user) {
//     res.status(403).send("Please Update User Profile First.");
//     return;
//   }

//   const user_id = db_user.id;
//   console.log(user_id);

//   const group = await prisma.group.findMany({
//     where: {
//       nanoId: group_nano_id,
//       users: {
//         some: { userId: user_id }, // Check the User dose participate in this Group.
//       },
//     },
//     include: {
//       users: {
//         include: { user: { select: { name: true } } },
//       },
//       childGroups: {
//         where: {
//           users: {
//             some: { userId: user_id }, // ChildGroups that the User participated in
//           },
//         },
//         // include: {
//         //   users: {
//         //     include: { user: { select: { name: true } } },
//         //   },
//         // },
//       },
//       meetings: {
//         where: {
//           users: {
//             some: { userId: user_id }, // Meetings that the User participated in
//           },
//         },
//         // include: {
//         //   users: {
//         //     include: { user: { select: { name: true } } },
//         //   },
//         // },
//       },
//     },
//   });

//   const groupItem = group[0]; // Since we used findMany, we unwrap the returned array.
//   if (!groupItem) {
//     res.status(404).send("No such group.");
//     return;
//   }

//   res.send(groupItem);
// });

export default router;
