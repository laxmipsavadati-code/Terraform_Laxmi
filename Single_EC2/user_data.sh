#!/bin/bash

set -e

# Update packages
apt-get update -y

# Install Python
apt-get install -y python3 python3-pip python3-venv

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Create application directories
mkdir -p /opt/flask-app
mkdir -p /opt/express-app

# -----------------------------
# Flask Application
# -----------------------------

cat > /opt/flask-app/app.py <<'PYTHON'
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Flask Backend is Running!"

@app.route("/api")
def api():
    return {
        "message": "Hello from Flask Backend",
        "status": "success"
    }

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
PYTHON

cat > /opt/flask-app/requirements.txt <<'REQUIREMENTS'
Flask==3.1.2
REQUIREMENTS

# Create Python virtual environment
cd /opt/flask-app
python3 -m venv venv

# Install Flask
/opt/flask-app/venv/bin/pip install -r requirements.txt

# Create Flask systemd service
cat > /etc/systemd/system/flask-app.service <<'SERVICE'
[Unit]
Description=Flask Backend Application
After=network.target

[Service]
User=root
WorkingDirectory=/opt/flask-app
ExecStart=/opt/flask-app/venv/bin/python /opt/flask-app/app.py
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

# -----------------------------
# Express Application
# -----------------------------

cat > /opt/express-app/server.js <<'JAVASCRIPT'
const express = require("express");

const app = express();

const PORT = 3000;

app.get("/", (req, res) => {
    res.send("Express Frontend is Running!");
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
JAVASCRIPT

cat > /opt/express-app/package.json <<'PACKAGE'
{
  "name": "express-frontend",
  "version": "1.0.0",
  "description": "Express frontend for Terraform AWS assignment",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^5.1.0"
  }
}
PACKAGE

# Install Express
cd /opt/express-app
npm install

# Create Express systemd service
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

# Reload systemd
systemctl daemon-reload

# Enable applications at boot
systemctl enable flask-app
systemctl enable express-app

# Start applications
systemctl start flask-app
systemctl start express-app

# Wait a few seconds
sleep 10

# Show status in cloud-init log
systemctl status flask-app --no-pager
systemctl status express-app --no-pager

echo "Flask and Express applications installed successfully."