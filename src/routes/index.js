import express from "express";

const router = express.Router();

// Healthcheck
router.get("/", (req, res) => {
    res.send("OK");
});

export default router;