import express from "express";
import { checkJwt } from "../auth.js";
import { PrismaClient, Role } from "@prisma/client";
import short_uuid from "short-uuid";

const router = express.Router();
const prisma = new PrismaClient();

router.use(checkJwt);
router.use(express.json());

router.post("/", async (req, res) => {
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
  }

  const user_id = db_user.id;
  const group_suuid = short_uuid.generate();
  const group_name = req.body.group_name;
  console.log(user_id);
  console.log(group_suuid);
  console.log(group_name);
  const group = await prisma.group.create({
    data: {
      sUUID: group_suuid,
      name: group_name,
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

  res.send(group);
});

// Get a list of Groups of a User
router.get("/", async (req, res) => {
  // Get Auth0 userID (i.e., sub) from JWT access token.
  const auth0UserID = req.auth.sub;
  console.log("Get Group by GET api/groups/: " + auth0UserID);

  // Serch for the user in DB
  let db_user = await prisma.user.findUnique({
    where: { userIdFromAuth0: auth0UserID },
  });

  // If the corresponding db_user do not exist, send 403.
  if (!db_user) {
    res.status(403).send("Please Update User Profile First.");
  }

  const user_id = db_user.id;
  console.log(user_id);
  // const groups = await prisma.user.findUnique({
  //   where: { userIdFromAuth0: auth0UserID },
  //   select: {
  //     groups: {
  //       include: {
  //         user: true,
  //       },
  //     },
  //   },
  // });

  const groups = await prisma.group.findMany({
    where: { users: { some: { userId: user_id } } },
    include: {
      users: {
        include: { user: true },
      },
    },
  });

  // const group = await prisma.group.create({
  //   data: {
  //     sUUID: group_suuid,
  //     name: group_name,
  //     users: {
  //       create: {
  //         user: {
  //           connect: { id: user_id },
  //         },
  //         role: Role.MANAGER,
  //       },
  //     },
  //   },
  //   include: {
  //     users: true,
  //   },
  // });

  res.send(groups);
});

// // Update User and return User.
// router.put("/", async (req, res) => {
//   // Get Auth0 userID (i.e., sub) from JWT access token.
//   const auth0UserID = req.auth.sub;

//   console.log("Update User by PUT api/users/: " + auth0UserID);
//   console.log(req.body);

//   const email = req.body.email;
//   const name = req.body.name;

//   // Serch for the user in DB
//   let db_user = await prisma.user.findUnique({
//     where: { userIdFromAuth0: auth0UserID },
//   });

//   // If the corresponding db_user do not exist, create one.
//   if (!db_user) {
//     await prisma.user.create({
//       data: {
//         userIdFromAuth0: auth0UserID,
//       },
//     });
//   }

//   // Update user info.
//   await prisma.user.update({
//     where: { userIdFromAuth0: auth0UserID },
//     data: {
//       email: email,
//       name: name,
//     },
//   });

//   db_user = await prisma.user.findUnique({
//     where: { userIdFromAuth0: auth0UserID },
//   });

//   res.send(db_user);
// });

export default router;
