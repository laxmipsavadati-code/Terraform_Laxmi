const express = require("express");

const app = express();

const PORT = 3000;

app.get("/", (req, res) => {
    res.send("Express Frontend is Running on Separate EC2!");
});

app.get("/health", (req, res) => {
    res.json({
        status: "healthy",
        service: "express-frontend"
    });
});

app.get("/api", (req, res) => {
    res.json({
        message: "Hello from Express Frontend",
        status: "success"
    });
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Express frontend running on port ${PORT}`);
});