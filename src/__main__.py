from flask import Flask
from flask import render_template
import logging

app = Flask(__name__)

logging.basicConfig(level=logging.INFO)


@app.route("/")
def hello_world():
    return "hello"


@app.route("/hello")
def hello_templates():
    return render_template("hello.html", thing="test")


@app.route("/hello/<thing>")
def hello_dynamic(thing=None):
    return render_template("hello.html", thing=thing)


@app.route("/home")
def home():
    return render_template("home.html")


if __name__ == "__main__":
    logging.info("Starting...")
    app.run()
