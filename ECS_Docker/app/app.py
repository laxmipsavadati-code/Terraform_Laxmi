from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Docker Flask Application is Running Successfully!"

@app.route("/health")
def health():
    return "Healthy"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)