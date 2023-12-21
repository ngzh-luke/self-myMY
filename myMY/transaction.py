""" transaction """
from flask import Blueprint, redirect, url_for, render_template, flash
from flask_login import login_required, current_user

t = Blueprint("transaction", __name__)


@t.route("/home/", methods=['GET'])
@login_required
def transactionHome():
    return render_template("transaction.html", user=current_user)

@t.route("/get/", methods=['GET'])
@login_required
def transactionGet():
    return render_template("get.html", user=current_user)

@t.route("/edit/", methods=['GET'])
@login_required
def transactionEdit():
    return render_template("edit.html", user=current_user)
