import express from "express";

const router = express.Router();

// Healthcheck
router.get("/", (req, res) => {
  const key = req.query["key"];
  if (key === "true") {
    res.send("true");
  } else if (key === "false") {
    res.send("false");
  } else {
    res.send("Ok");
  }
});

export default router;
