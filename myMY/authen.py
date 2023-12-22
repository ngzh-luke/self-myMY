""" authentication to system """
from flask import render_template, Blueprint, request, redirect, url_for, session, abort, flash
from flask_login import login_user, login_required, logout_user, current_user, login_fresh
from flask_bcrypt import check_password_hash, generate_password_hash
from .models import User, SignupCode
from myMY import db
import time
import json
from datetime import datetime, timezone

iden = Blueprint('auth', __name__)


@iden.route('/request/logout/')  # 127.0.0.1:5500/iden-operation/request/logout
@iden.route('/logout/')  # 127.0.0.1:5500/iden-operation/logout
@login_required
# log user out
def logout():
    session.clear()
    logout_user()
    flash('Please login again!',
          category='logout')
    session['current'] = '/logout'
    return redirect(url_for('auth.login'))


@iden.route('/login/', methods=["GET"])  # 127.0.0.1:5500/iden-operation/login
# 127.0.0.1:5500/iden-operation/request/login
@iden.route("/request/login", methods=["POST"])
# log user in
def login():
    try:
        # if user already logged in
        if User.get_id(current_user):
            return redirect(url_for("acc.myAcc"))
    except:
        pass
    if request.method == 'POST':
        name = request.form.get('inputUsername')
        password = request.form.get('inputPassword')
        user = User.query.filter_by(uname=name).first()
        if user:
            # comparing two given parameters
            if check_password_hash(user.password, password):

                # remember = False cause session timeout implemented and this could override timeout session
                login_user(user, remember=False)
                # Otherwise, could be set to true
                session['loginTime'] = datetime.now(tz=timezone.utc)
                flash('Welcome, "' + name + '"!', category='login')

                return redirect(url_for("acc.myAcc"))

            else:
                flash("Password or the username is incorrect!", category='error')
                return redirect(url_for("redirector.toLogin"))
        else:
            flash(
                "Password or the username is incorrect!", category='error')
            return redirect(url_for("redirector.toLogin"))

    return render_template('login.html', user=current_user)


# 127.0.0.1:5500/inden-operation/signup
@iden.route('/signup/', methods=["GET"])
# 127.0.0.1:5500/iden-operation/request/signup
@iden.route('/request/signup', methods=["POST"])
# sign up
def signup():
    if current_user.is_authenticated:
        flash("Please logout to continue!", category='info')
        return redirect(url_for("acc.myAcc"))
    if request.method == "POST":
        newAcc = None
        name = request.form.get('inputUsername')
        password = request.form.get('inputPassword')
        password2 = request.form.get('inputPassword2')
        signupcode = request.form.get('inputSignupCode')
        code = SignupCode.query.filter_by(code=signupcode, isused=False).first() # get unused code
        user = User.query.filter_by(uname=name).first()
        if user != None:
            # if user is exists
            flash("This username is already taken!", category='warning')
            return redirect(url_for("redirector.toSignup"))
        if password2 != password:
            # if passwords are not matched
            flash("Passwords are not matched!", category='warning')
            return redirect(url_for("redirector.toSignup"))
        elif (code == None) or (code.code != signupcode):
            # if submitted code is match with code from server
            flash("Signup code is invalid! Please contact admin", category='warning')
            return redirect(url_for("redirector.toSignup"))
        else:
            try:
                # create new account
                newAcc = User(uname=name, password=generate_password_hash(
                    password).decode('utf-8'), alias=name)
                code.isused = True
                db.session.add(newAcc)
                db.session.commit()

                flash("Your account has been created!", category='success')
                return redirect(url_for("redirector.toLogin"))
            except Exception as e:
                flash(
                    f"Encounter error(s), couldn't create account, please try again<br>ERR: {e}", category='danger')
                return redirect(url_for("redirector.toSignup"))

    return render_template("signup.html", user=current_user)
