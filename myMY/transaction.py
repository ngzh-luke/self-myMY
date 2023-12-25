""" transaction """
from flask import Blueprint, redirect, url_for, render_template, flash, request
from flask_login import login_required, current_user
from .models import Transaction
from myMY import db
from .customErrorClass import confirmationError
# from builtins import ty

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
        delCon = request.args.get("delCon")
        if (delCon == None) or (delCon == "None"):
            raise confirmationError()
        else:
            result = Transaction.query.filter_by(id=tid).first()
            if (result == None) or (result == "None"):
                raise AttributeError(obj={'msg':"Transaction does not exist"})
            db.session.delete(result)
            db.session.commit()
            flash('Transaction deleted!', category = 'success')
    except ValueError as ve:
        flash(message=str(f"Invalid transation ID given. [{ve}]"), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    except confirmationError:
        flash(message=str("Unable to delete transaction! due to no user confirmation!"), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    except AttributeError as ae:
        flash(message=str(f"Given transaction ID can't be found! [{ae.obj['msg']}]"), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    except Exception as e:
        flash(message="Unable to delete transaction! <br> ERR:{}".format(e), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    return redirect(url_for("redirector.toTransactionHome"))