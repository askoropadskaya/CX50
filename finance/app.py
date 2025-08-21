import os

from cs50 import SQL
from datetime import datetime
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd
import requests

# Configure application
app = Flask(__name__)

# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")

quote_url = "https://api.iex.cloud/v1/data/core/quote/"
quote_token = "?token=pk_f6cfe358f0e44009a73d08c7c8d1fe41"


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""

    stocks = db.execute(
        "SELECT symbol, company_name, number FROM stocks WHERE user_id = ?",
        session["user_id"],
    )
    grand_total = 0
    for s in stocks:
        data = lookup(s["symbol"])
        s["price"] = data["price"]
        s["total"] = round(s["price"] * s["number"], 2)
        grand_total += s["price"] * s["number"]

    users = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
    user = users[0]
    cash = user["cash"]

    total = cash + grand_total
    # return render_template("layout.html")
    return render_template(
        "index.html", stocks=stocks, cash=round(cash, 2), total=round(total, 2)
    )


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    if request.method == "POST":
        symbol = request.form.get("symbol")
        if symbol == None:
            return apology("Enter a valid symbol")
        shares = None
        try:
            shares = int(request.form.get("shares"))
        except:
            return apology("Enter a valid number")

        if shares <= 0:
            return apology("Enter a positive number")

        data = lookup(symbol)
        if data == None:
            return apology("Enter a valid symbol")
        totalTransactionPrice = data["price"] * shares
        users = db.execute("SELECT * FROM users WHERE id = ?", session["user_id"])
        cashAfterTransaction = users[0]["cash"] - totalTransactionPrice

        if cashAfterTransaction < 0:
            return apology("Oops, Not enough money to buy")

        db.execute(
            "UPDATE users SET cash = ? WHERE id = ?",
            cashAfterTransaction,
            session["user_id"],
        )
        currentDateTime = datetime.now()
        db.execute(
            "INSERT INTO transactions (user_id, symbol, company_name, quantity, price, date, type) VALUES (?, ?, ?, ?, ?, ?, ?)",
            session["user_id"],
            data["symbol"],
            data["name"],
            shares,
            data["price"],
            currentDateTime,
            "buy",
        )
        stocks = db.execute(
            "SELECT * FROM stocks WHERE user_id = ? AND symbol = ? COLLATE NOCASE",
            session["user_id"],
            symbol,
        )

        if len(stocks) == 0:
            db.execute(
                "INSERT INTO stocks (user_id, symbol, company_name, number) VALUES (?, ?, ?, ?)",
                session["user_id"],
                data["symbol"],
                data["name"],
                shares,
            )
        else:
            db.execute(
                "UPDATE stocks SET number = ? WHERE id = ?",
                stocks[0]["number"] + shares,
                stocks[0]["id"],
            )
        return redirect("/")
    else:
        return render_template("buy.html", nav_item="buy")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    usersTransactions = db.execute(
        "SELECT symbol, company_name, quantity, price, type, date FROM transactions WHERE user_id = ?",
        session["user_id"],
    )

    return render_template(
        "history.html", usersTransactions=usersTransactions, nav_item="history"
    )


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute(
            "SELECT * FROM users WHERE username = ?", request.form.get("username")
        )

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(
            rows[0]["hash"], request.form.get("password")
        ):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""
    # https://api.iex.cloud/v1/data/core/quote/nflx?token=API_KEY
    if request.method == "POST":
        symbol = request.form.get("symbol")
        if symbol == "":
            return apology("Symbol is empty", 400)

        data = lookup(symbol)
        if data == None:
            return apology("Quote not found", 400)

        return render_template("quoted2.html", data=data)
    else:
        return render_template("/quote.html", nav_item="quote")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 400)

        # Ensure password was submitted
        if not request.form.get("password"):
            return apology("must provide password", 400)

        # Ensure repeat password was submitted
        if not request.form.get("confirmation"):
            return apology("must repeat the password", 400)

        # Ensure passwords match
        if not checkPasswordMatch():
            return apology("Passwords dont match", 400)

        # Query database for username
        rows = db.execute(
            "SELECT * FROM users WHERE username = ?", request.form.get("username")
        )
        print(rows)
        # Ensure username does not exist
        if len(rows) > 0:
            return apology("User already exists, please login instead", 400)

        # Add user to the database
        db.execute(
            "INSERT INTO users (username, hash) VALUES (?, ?)",
            request.form.get("username"),
            generate_password_hash(request.form.get("password")),
        )
        rows = db.execute(
            "SELECT * FROM users WHERE username = ?", request.form.get("username")
        )

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("register.html")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""
    if request.method == "POST":
        symbol = request.form.get("symbol")
        shares = int(request.form.get("shares"))

        if shares <= 0:
            return apology("Enter a positive number")
        if symbol == None:
            return apology("Enter a valid symbol")

        userStockQuantity = db.execute(
            "SELECT number, id FROM stocks WHERE user_id = ? AND symbol = ? COLLATE NOCASE",
            session["user_id"],
            symbol,
        )

        if userStockQuantity[0]["number"] < shares:
            return apology("Oops, Not enough shares")

        data = lookup(symbol)
        totalTransactionPrice = data["price"] * shares
        users = db.execute("SELECT * FROM users WHERE id = ?", session["user_id"])
        cashAfterTransaction = users[0]["cash"] + totalTransactionPrice

        db.execute(
            "UPDATE users SET cash = ? WHERE id = ?",
            cashAfterTransaction,
            session["user_id"],
        )
        currentDateTime = datetime.now()
        db.execute(
            "INSERT INTO transactions (user_id, symbol, company_name, quantity, price, date, type) VALUES (?, ?, ?, ?, ?, ?, ?)",
            session["user_id"],
            data["symbol"],
            data["name"],
            shares,
            data["price"],
            currentDateTime,
            "sell",
        )

        db.execute(
            "UPDATE stocks SET number = ? WHERE id = ?",
            userStockQuantity[0]["number"] - shares,
            userStockQuantity[0]["id"],
        )

        return redirect("/")
    else:
        userStockSymbols = db.execute(
            "SELECT symbol FROM stocks WHERE user_id = ?", session["user_id"]
        )
        return render_template(
            "sell.html", userStockSymbols=userStockSymbols, nav_item="sell"
        )


def checkPasswordMatch():
    password = request.form.get("password")
    confirmation = request.form.get("confirmation")
    if confirmation == password:
        return True

    return False
