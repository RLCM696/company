import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

# from helpers import apology, login_required, lookup, usd

from helpers import login_required

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
    return render_template("index.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    # Register user
    if request.method == "POST":
        # Checking for an username
        if not request.form.get("username"):
            flash("Username required")
            return redirect("/register")

        # Checking for a password
        if not request.form.get("password"):
            flash("Pasword required")
            return redirect("/register")

        # Checking for a confirmation password
        if nrequest.form.get("confirmation"):
            flash("Password confirmation required")
            return redirect("/register")

        # Checking for a match between password and confirmation
        if not request.form.get("confirmation") == request.form.get("password"):
            flash("Password confirmation and password fields must match")
            return redirect("/register")

        try:
            # Insert the new user into the database
            db.execute(
                "INSERT INTO users (name, hash) VALUES (?, ?)",
                request.form.get("username"),
                generate_password_hash(request.form.get("password"))
                )
            # Set the new user as the current logged one
            session["user_id"] = db.execute("SELECT id FROM users WHERE name = ?", request.form.get("username"))
            return redirect("/")

        except ValueError as e:
            # If an exception hapen is because the username is already taken
            flash("The given username is already registered")
            return redirect("/register")

    else:
        return render_template("register.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    # Log user in
    # Get all registered users
    users = db.execute("SELECT * FROM users")

    # If any user registered then the current one shuold register itself
    if not len(users):
        return redirect("/register")

    session["user_id"] = 1
    return redirect("/")


@app.route("/logout")
def logout():
    # Log user out

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


