from os import name

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
