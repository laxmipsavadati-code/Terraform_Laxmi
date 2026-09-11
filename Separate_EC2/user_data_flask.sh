#!/bin/bash

set -e

# Update packages
apt-get update -y

# Install Python
apt-get install -y python3 python3-pip python3-venv

# Create Flask application directory
mkdir -p /opt/flask-app

# Create Flask application
cat > /opt/flask-app/app.py <<'PYTHON'
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Flask Backend is Running on Separate EC2!"

@app.route("/health")
def health():
    return {
        "status": "healthy",
        "service": "flask-backend"
    }

@app.route("/api")
def api():
    return {
        "message": "Hello from Flask Backend",
        "status": "success"
    }

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
PYTHON

# Create requirements file
cat > /opt/flask-app/requirements.txt <<'REQUIREMENTS'
Flask==3.1.2
REQUIREMENTS

# Create Python virtual environment
cd /opt/flask-app
python3 -m venv venv

# Install Flask
/opt/flask-app/venv/bin/pip install -r requirements.txt

# Create systemd service
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

# Enable and start Flask
systemctl daemon-reload
systemctl enable flask-app
systemctl start flask-app

# Wait for Flask to start
sleep 5

# Check Flask status
systemctl status flask-app --no-pager

echo "Flask Backend installed and started successfully."