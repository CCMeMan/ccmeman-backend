import express from "express";
import { checkJwt } from "../auth.js";
import { PrismaClient } from "@prisma/client";

const router = express.Router();
const prisma = new PrismaClient();

router.use(checkJwt);
router.use(express.json());
// router.use(express.urlencoded());

// Create User or get existing User and return the User.
router.post("/", async (req, res) => {
  // Get Auth0 userID (i.e., sub) from JWT access token.
  const auth0UserID = req.auth.sub;
  console.log("Create/Get User by POST api/users/: " + auth0UserID);

  // Serch for the user in DB
  let db_user = await prisma.user.findUnique({
    where: { userIdFromAuth0: auth0UserID },
  });

  // If the corresponding db_user do not exist, create one.
  if (!db_user) {
    await prisma.user.create({
      data: {
        userIdFromAuth0: auth0UserID,
      },
    });
    db_user = await prisma.user.findUnique({
      where: { userIdFromAuth0: auth0UserID },
    });
  }

  res.send(db_user);
});

// Update User and return User.
router.put("/", async (req, res) => {
  // Get Auth0 userID (i.e., sub) from JWT access token.
  const auth0UserID = req.auth.sub;

  console.log("Update User by PUT api/users/: " + auth0UserID);
  console.log(req.body);

  const email = req.body.email;
  const name = req.body.name;

  // Serch for the user in DB
  let db_user = await prisma.user.findUnique({
    where: { userIdFromAuth0: auth0UserID },
  });

  // If the corresponding db_user do not exist, create one.
  if (!db_user) {
    await prisma.user.create({
      data: {
        userIdFromAuth0: auth0UserID,
      },
    });
  }

  // Update user info.
  await prisma.user.update({
    where: { userIdFromAuth0: auth0UserID },
    data: {
      email: email,
      name: name,
    },
  });

  db_user = await prisma.user.findUnique({
    where: { userIdFromAuth0: auth0UserID },
  });

  res.send(db_user);
});

export default router;
