import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

# from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Custom filter
# app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///company.db")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/", methods=["GET", "POST"])
@login_required
def index():
    """Show portfolio of stocks"""
    info = db.execute("SELECT * FROM users WHERE id = ?", session["user_id"])
    if len(info):
        total = info[0]["cash"]
        shares = db.execute(
            "SELECT symbol, amount FROM shares WHERE user_id = ?", session["user_id"])
        for share in shares:
            share["price"] = lookup(share["symbol"])["price"]
            share["total"] = share["price"] * share["amount"]
            total += share["total"]
        return render_template("index.html", shares=shares, cash=info[0]["cash"], total=total)
    else:
        return render_template("login.html")
