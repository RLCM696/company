import requests
from datetime import datetime

from flask import redirect, render_template, session
from functools import wraps

def login_required(f):
    """
    Decorate routes to require login.

    https://flask.palletsprojects.com/en/latest/patterns/viewdecorators/
    """

    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get("user_id") is None:
            return redirect("/login")
        return f(*args, **kwargs)

    return decorated_function

def pending(value: list[dict]):
    # Return the number of pending tasks in a list of tasks
    return sum(["Finished" not in val["status"] for val in value])

def date_tool(value: str):
    # Convert string to datetime object
    date_obj = datetime.strptime(value, "%Y-%m-%d %H:%M:%S")

    # Convert datetime object to different format
    new_date_str = date_obj.strftime("%d/%m/%Y %I:%M %p")
    return
