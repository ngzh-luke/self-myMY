""" account """
from flask import Blueprint, render_template, url_for, flash, request, redirect
from flask_login import current_user, login_required
from flask_bcrypt import generate_password_hash, check_password_hash
from .models import User
from myMY import db

acc = Blueprint('acc', __name__)


@acc.route("/my-account")  # localhost:5500/account/my-account
@login_required
# account home
def myAcc():
    return render_template("account.html", user=current_user)


# localhost:5500/account/my-account/account-manager
@acc.route("my-account/account-manager")
@login_required
# account manager
def accManager():
    return render_template("account.html", user=current_user, title='Account Manager')


# localhost:5500/account/my-account/account-manager/change-password
@acc.route("/my-account/account-manager/change-password", methods=["POST"])
@login_required
# update password
def updatePswd():
    try:
        user = current_user
        curPswd = request.form.get("inputCurrentPassword")
        newPswd = request.form.get("newPassword")
        conNewPswd = request.form.get("newPassword2")
        if check_password_hash(user.password, curPswd):
            if newPswd != conNewPswd:
                flash("Passwords are not matched!", category='warning')

            else:
                newPswd = generate_password_hash(newPswd)
                user.password = newPswd
                db.session.commit()

                flash("Your password has been updated!", category='success')
            return redirect(url_for("acc.accManager"))
        else:
            flash("Password is incorrect!", category='error')
            return redirect(url_for("acc.accManager"))

    except:

        flash("Encounter error(s), couldn't update your change(s), please try again",
              category='danger')
        return redirect(url_for("acc.accManager"))
    finally:
        return redirect(url_for("acc.accManager"))
    return render_template("account.html", user=current_user, title='Account Manager')


# localhost:5500/account/my-account/account-manager/change-alias
@acc.route("/my-account/account-manager/change-alias", methods=["POST"])
@login_required
# update alias
def updateAlias():
    try:
        user = current_user
        curAlias = request.form.get("inputCurrentAlias")
        newAlias = request.form.get("newAlias")
        conNewAlias = request.form.get("newAlias2")
        if user.alias == curAlias:
            if newAlias != conNewAlias:
                flash("Alias are not matched!", category='warning')

            else:

                user.alias = newAlias

                db.session.commit()

            flash("Your changes has been updated!", category='success')
            return redirect(url_for("acc.accManager"))
        else:
            flash("Alias is incorrect!", category='error')
            return redirect(url_for("acc.accManager"))

    except:

        flash("Encounter error(s), couldn't update your change(s), please try again",
              category='danger')
        return redirect(url_for("acc.accManager"))
    finally:
        return redirect(url_for("acc.accManager"))
    return render_template("account.html", user=current_user, title='Account Manager')


# localhost:5500/account/my-account/account-manager/delete-account
@acc.route("/my-account/account-manager/delete-account", methods=["POST"])
@login_required
# delete account
def delAcc():
    try:
        user = current_user
        curPswd = request.form.get("inputCurrentPassword")
        if check_password_hash(user.password, curPswd):
            db.session.delete(user)
            db.session.commit()
            flash("Your account is deleted!", category='success')
            return redirect(url_for("rootView.redirectToSignup"))
        else:
            flash("Password is incorrect!", category='error')
            return redirect(url_for("acc.accManager"))

    except:

        flash("Encounter error(s), action couldn't be done, please try again",
              category='danger')
        return redirect(url_for("acc.accManager"))
