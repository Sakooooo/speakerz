from flask import Flask
from flask import render_template

app = Flask(__name__)


@app.route("/")
def hello_world():
    return "hello"


@app.route("/hello")
def hello_templates():
    return render_template("hello.html", thing="test")


@app.route("/hello/<thing>")
def hello_dynamic(thing=None):
    return render_template("hello.html", thing=thing)


if __name__ == "__main__":
    print("Ok")
    app.run()
