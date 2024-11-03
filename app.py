import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import login_required, pending

# Configure application
app = Flask(__name__)

# Custom filter
app.jinja_env.filters["pending"] = pending

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///arches.db")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/", methods=["GET"])
@login_required
def index():
    projects = db.execute("""SELECT status, permission, company, address, zip_code, city, state, date,
                           Projects.id, Clients.name AS client FROM Projects
                           JOIN Clients ON Projects.client_id = Clients.id""")

    return render_template("index.html", projects=projects)


@app.route("/register", methods=["GET", "POST"])
def register():
    # Register user
    if request.method == "POST":
        # Checking for an username
        if not request.form.get("username"):
            flash("Username required")
            return render_template("register.html", username=request.form.get("username"), password=request.form.get("password"),
                            confirmation=request.form.get("confirmation"))

        # Checking for a password
        if not request.form.get("password"):
            flash("Pasword required")
            return render_template("register.html", username=request.form.get("username"), password=request.form.get("password"),
                            confirmation=request.form.get("confirmation"))

        # Checking for a confirmation password
        if not request.form.get("confirmation"):
            flash("Password confirmation required")
            return render_template("register.html", username=request.form.get("username"), password=request.form.get("password"),
                            confirmation=request.form.get("confirmation"))

        # Checking for a match between password and confirmation
        if not request.form.get("confirmation") == request.form.get("password"):
            flash("Password confirmation and password fields must match")
            return render_template("register.html", username=request.form.get("username"), password=request.form.get("password"),
                            confirmation=request.form.get("confirmation"))

        try:
            # Insert the new user into the database
            db.execute(
                "INSERT INTO Users (name, hash) VALUES (?, ?)",
                request.form.get("username"),
                generate_password_hash(request.form.get("password"))
                )
            # Set the new user as the current logged one
            session["user_id"] = db.execute("SELECT id FROM Users WHERE name = ?", request.form.get("username"))
            return redirect("/")

        except ValueError as e:
            # If an exception hapen is because the username is already taken
            flash("The given username is already registered")
            return render_template("register.html", username=request.form.get("username"), password=request.form.get("password"),
                            confirmation=request.form.get("confirmation"))

    else:
        return render_template("register.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    # Log user in
    if request.method == "POST":
        # Checking for an username
        if not request.form.get("username"):
            flash("Username required")
            return render_template("login.html", username=request.form.get("username"), password=request.form.get("password"))

        # Checking for a password
        if not request.form.get("password"):
            flash("Pasword required")
            return render_template("register.html", username=request.form.get("username"), password=request.form.get("password"))

        # Checking the user data
        user = db.execute("SELECT * FROM users WHERE name = ?", request.form.get("username"))
        if not len(user):
            flash("The given username or password are not registered")
            return render_template("register.html", username=request.form.get("username"), password=request.form.get("password"))

        if not check_password_hash(user[0]["hash"], request.form.get("password")):
            flash("The given username or password are not registered")
            return render_template("register.html", username=request.form.get("username"), password=request.form.get("password"))

        session["user_id"] = user[0]["id"]
        return redirect("/")

    else:
        # If there is no user registered then the current one shuold register itself
        if not len(db.execute("SELECT * FROM Users LIMIT 1")):
            return redirect("/register")

        return render_template("login.html")


@app.route("/logout")
def logout():
    # Log user out

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/project", methods=["GET", "POST"])
def contract():
    if request.method == "GET":
        project = db.execute("""SELECT status, permission, company, address, zip_code, city, state, date,
                             Projects.id, Clients.name AS client FROM Projects
                             JOIN Clients ON Projects.client_id = Clients.id
                             WHERE Projects.id = ?""", request.args.get('project'))[0]

        tasks = db.execute("""SELECT start_date, due_date, ProjectTasks.status, ProjectTasks.id, Tasks.name AS task,
                           Tasks.description, Stages.name AS stage, Teams.name AS team, Employees.first_name AS lead
                           FROM ProjectTasks
                           JOIN Tasks ON ProjectTasks.task_id = Tasks.id
                           JOIN Stages ON Tasks.stage_id = Stages.id
                           JOIN Teams ON ProjectTasks.team_id = Teams.id
                           JOIN Employees ON Teams.lead_id = Employees.id
                           WHERE project_id = ?""", request.args.get('project'))

        return render_template("project.html", project = project, tasks = tasks)

