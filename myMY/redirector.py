""" redirector """
from flask import Blueprint, redirect, url_for

r = Blueprint("redirector", __name__)


@r.route("/", methods=['GET'])
def toHome():
    return redirect(url_for("acc.myAcc"))


@r.route("/login/", methods=['GET'])
def toLogin():
    return redirect(url_for("auth.login"))


@r.route("/signup/", methods=['GET'])
def toSignup():
    return redirect(url_for("auth.signup"))


@r.route("/logout/", methods=['GET'])
def toLogout():
    return redirect(url_for("auth.logout"))