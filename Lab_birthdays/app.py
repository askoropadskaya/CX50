import os
import string

from cs50 import SQL
from flask import Flask, flash, jsonify, redirect, render_template, request, session

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///birthdays.db")

MONTHS = [
    "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
]

@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":

        # Add the user's entry into the database
        name = request.form.get("name")
        month =  request.form.get("month")
        print(month)
        day = int(request.form.get("day"))

        err = None

        if len(name.strip()) == 0:
            err = True

        if month == None:
            err = True
        if day < 1 and 31 > day:
            err = True
        if err == False:
            db.execute("INSERT INTO birthdays (name, month, day) VALUES (?, ?, ?)", name, monthToNum(month), day)

        return redirect("/")

    else:

        # Display the entries in the database on index.html
        birthdays = db.execute("SELECT * FROM birthdays")
        return render_template("index.html", birthdays=birthdays, months=MONTHS)

def monthToNum(month):
    return MONTHS.index(month)+1
