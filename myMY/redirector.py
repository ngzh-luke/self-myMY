""" redirector """
from flask import Blueprint, redirect, url_for, session, request

r = Blueprint("redirector", __name__)


@r.route("/", methods=['GET'])
def toHome():
    session['last'] = request.endpoint
    return redirect(url_for("acc.myAcc"))


@r.route("/login/", methods=['GET'])
def toLogin():
    session['last'] = request.endpoint
    return redirect(url_for("auth.login"))


@r.route("/signup/", methods=['GET'])
def toSignup():
    session['last'] = request.endpoint
    return redirect(url_for("auth.signup"))


@r.route("/logout/", methods=['GET'])
def toLogout():
    session['last'] = request.endpoint
    return redirect(url_for("auth.logout"))


@r.route("/transaction/home/", methods=['GET'])
def toTransactionHome():
    session['last'] = request.endpoint
    return redirect(url_for("transaction.transactionHome"))


@r.route("/transaction/lookup/", methods=['GET'])
def toTransactionLookup():
    session['last'] = request.endpoint
    return redirect(url_for("transaction.transactionGet"))


@r.route("/transaction/del/", methods=['GET'])
def toTransactionDel():
    session['last'] = request.endpoint
    return redirect(url_for("transaction.transactionDelLanding"))


@r.route('transaction/export/', methods=['GET'])
def toTransactionExport():
    session['last'] = request.endpoint
    return redirect(url_for('tx.exportLanding'))
