""" transaction """
from flask import Blueprint, redirect, url_for, render_template, flash, request
from flask_login import login_required, current_user
from .models import Transaction
from myMY import db

t = Blueprint("transaction", __name__)


@t.route("/home/", methods=['GET'])
@login_required
def transactionHome():
    return render_template("transaction.html", user=current_user)

@t.route("/get/", methods=['GET'])
@login_required
def transactionGet():
    g = Transaction.query.filter_by(user_id=current_user.id).all()

    return render_template("get.html", user=current_user, get=g, total=None)

@t.route("/edit/", methods=['GET'])
@login_required
def transactionEdit():
    return render_template("edit.html", user=current_user)

@t.route("/new/", methods=['POST'])
@login_required
def transactionNew():
    
    if request.method == "POST":
        inputType = request.form.get("typee")
        inputParty = request.form.get("party") 
        inputVia = request.form.get("via")
        inputCurrency = request.form.get("currency") 
        inputLocation = request.form.get("place")
        inputCountry = request.form.get("country") 
        inputDTime = request.form.get("dtime")
        inputNotes = request.form.get("notes") 
        inputAmount = request.form.get("amount")
        # flash(f"{inputType} {inputAmount} {inputCountry} {inputCurrency} {inputCountry} {inputDTime} {inputLocation} {inputVia}")
        try:
            newT = Transaction(typee=inputType,amount=inputAmount,currency=inputCurrency,party=inputParty,via=inputVia,location=inputLocation,notes=inputNotes,country=inputCountry,dtime=inputDTime, user_id=current_user.id)
            db.session.add(newT)
            db.session.commit()
            flash('Transaction created!', category = 'success')
            return redirect(url_for("redirector.toTransactionHome"))
           
        except Exception as e:
            flash(f"Unable to create new transaction, please try again later!<br>ERR: {e}", category='error')
            return redirect(url_for("redirector.toTransactionHome"))
    return redirect(url_for("redirector.toTransactionHome"))

@t.route("/edit/confirm/", methods=['POST'])
@login_required
def transactionEditConfirm():
    inputTID = request.form.get("tid")
    return redirect(url_for("transaction.transactionHome"))


@t.route("/search/delete", methods=['GET'])
@login_required
def transactionSeDel():
    
    try:
        tid = int(request.args.get("tid"))
        result = Transaction.query.filter_by(id=tid).first()
        db.session.delete(result)
        db.session.commit()
        flash('Transaction deleted!', category = 'success')
    except Exception as e:
        flash(message=f"Unable to delete transaction<br>ERR:{e}", category='error')
        return redirect(url_for("redirector.toTransactionHome"))
    return redirect(url_for("redirector.toTransactionHome"))