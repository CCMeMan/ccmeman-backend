import express from "express"; 
import dotenv from "dotenv-defaults";

// Import Routers
import router_index from "./routes/index.js";

// Init
const app = express();
dotenv.config();

// Routing
app.use("/", router_index);

// Listen
const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});