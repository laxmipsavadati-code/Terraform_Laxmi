#!/bin/bash

set -e

apt-get update -y
apt-get install -y curl

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

mkdir -p /opt/express-app

cat > /opt/express-app/server.js <<'JAVASCRIPT'
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
        message: "Hello from Express Backend",
        status: "success"
    });
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Express frontend running on port ${PORT}`);
});
JAVASCRIPT

cat > /opt/express-app/package.json <<'PACKAGE'
{
  "name": "express-frontend",
  "version": "1.0.0",
  "description": "Express frontend for separate EC2 deployment",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^5.1.0"
  }
}
PACKAGE

cd /opt/express-app
npm install

cat > /etc/systemd/system/express-app.service <<'SERVICE'
[Unit]
Description=Express Frontend Application
After=network.target

[Service]
User=root
WorkingDirectory=/opt/express-app
ExecStart=/usr/bin/node /opt/express-app/server.js
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable express-app
systemctl start express-app

sleep 5

systemctl status express-app --no-pager

echo "Express Frontend installed and started successfully."