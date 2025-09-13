from flask import Flask, render_template
import os

app = Flask(__name__)

VERSION = os.environ.get("APP_VERSION", "v1.0.0")

@app.route("/")
def index():
    return render_template("index.html", version=VERSION)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
