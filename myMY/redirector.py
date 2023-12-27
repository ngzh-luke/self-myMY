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

@r.route("/transaction/home/", methods=['GET'])
def toTransactionHome():
    return redirect(url_for("transaction.transactionHome"))

@r.route("/transaction/lookup/", methods=['GET'])
def toTransactionLookup():
    return redirect(url_for("transaction.transactionGet"))

@r.route("/transaction/del/", methods=['GET'])
def toTransactionDel():
    return redirect(url_for("transaction.transactionDelLanding"))