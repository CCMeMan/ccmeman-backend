import express from "express"; 
import dotenv from "dotenv-defaults";

// Import Routers
import router_index from "./routes/index.js";
import router_users from "./routes/users.js";
import router_groups from "./routes/groups.js";

// Init
const app = express();
dotenv.config();

// Routing
app.use("/", router_index);
app.use("/api/v1/users", router_users);
app.use("/api/v1/groups", router_groups);


// Listen
const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});