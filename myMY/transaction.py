""" transaction related operations """
from flask import Blueprint, redirect, url_for, render_template, flash, request, session  # Response, jsonify, session
from flask_login import login_required, current_user
from .models import Transaction
from myMY import db
from .customErrorClass import confirmationError
from datetime import datetime, timezone, timedelta
from .totalCal import totalCal
# import requests as rq
# from builtins import ty

t = Blueprint("transaction", __name__)


""" functions below is helpers functions for get(lookup) transaction(s) """


def getLocalTime():
    """ # Returns
    - `server time` if the client local time is undefined, `else local time`
      """
    # Specify the UTC offset for Bangkok (UTC+7)
    bkk_timezone_offset = timedelta(hours=7)
    # Create a timezone object for Bangkok
    bkk_timezone = timezone(bkk_timezone_offset)
    # Get the current time in Bangkok timezone
    bkk_time = datetime.now(bkk_timezone)
    # Format the time string
    t = bkk_time.strftime("%Y-%m-%d @%H:%M:%S [GMT+7]")
    try:
        # get local time (function defined in `__init__.py`)
        t = session['LCT']
    except:
        pass
    return t


def mc(records: list | None = None):
    itemsAmount = None if type(records) != list else len(
        records)  # amount of the queried transactions
    if itemsAmount == None:
        return None
    totalAmount = totalCal()
    INFLOW = ['income', 'refund']  # list of in flow transations
    OUTFLOW = ['outcome', 'donate', 'invest']  # list of out flow transactions
    for i in range(itemsAmount):  # perform calculation
        totalAmount.addIncome(
            income=records[i].amount if records[i].typee in INFLOW else 0.0, currency=records[i].currency)
        if (records[i].typee in OUTFLOW):
            totalAmount.addOutcome(
                outcome=records[i].amount, currency=records[i].currency)
    return totalAmount, itemsAmount


""" a function below is for get(lookup) transaction(s) """


@t.route("/get", methods=['GET'])
@login_required
def transactionGet():

    totalAmount, recordsAmount = 0, 0
    t = getLocalTime()
    filter_type = request.args.get('type')
    # filter_date = ''
    # no arg(all) = -1, arg1 = 0, arg2 = 1, arg3 = 2, arg1+arg2 = 3, arg2+arg3 = 5, arg1+arg2+arg3 = 6
    operation = -1
    if filter_type != None:
        operation = 0
    # flash(message='Unable to get records due to invalid filter(s)!', category='error') if filter_type == None else None
    records = None
    TYPES = ['income', 'outcome', 'donate', 'invest', 'transfer',
             'owe', 'exchange', 'deposit', 'withdrawal', 'refund']
    if ((filter_type in TYPES) and (operation == 0)):  # if valid arg1 is received
        ft = filter_type
        typeIndex = TYPES.index(filter_type)
        try:
            records = Transaction.query.filter_by(
                user_id=current_user.id, typee=TYPES[typeIndex]).all()
            totalAmount, recordsAmount = mc(records=records)
        except Exception as e:
            flash(
                message=f'Unable to retrieve transaction records: {e}', category='error')
    elif filter_type == None:  # if no args received then show landing page
        ft = None
        return render_template('getLanding.html', user=current_user)
        # flash(message='Unable to get records!', category='error')
    elif filter_type == 'all':
        ft = '[all]'
        try:
            records = Transaction.query.filter_by(
                user_id=current_user.id).all()
            totalAmount, recordsAmount = mc(records=records)
        except Exception as e:
            flash(
                message=f'Unable to retrieve transaction records: {e}', category='error')
    else:
        flash(message='Unable to retrieve transaction records due to invalid filter!', category='error')
        return render_template("get.html", user=current_user)

    return render_template("get.html", user=current_user, get=records, total=totalAmount, time=t, filter=ft, recordsAmount=f'{recordsAmount} records' if recordsAmount > 1 else f'{recordsAmount} record')


""" functions below are for add new transaction record """


@t.get('/new/')
@login_required
def transactionHome():
    return render_template("transaction.html", user=current_user)


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
            newT = Transaction(typee=inputType, amount=inputAmount, currency=inputCurrency, party=inputParty, via=inputVia,
                               location=inputLocation, notes=inputNotes, country=inputCountry, dtime=inputDTime, user_id=current_user.id)
            db.session.add(newT)
            db.session.commit()
            flash('Transaction created!', category='success')
            return redirect(url_for("redirector.toTransactionHome"))

        except Exception as e:
            flash(
                f"Unable to create new transaction, please try again later!<br>ERR: {e}", category='error')
            return redirect(url_for("redirector.toTransactionHome"))
    return redirect(url_for("redirector.toTransactionHome"))

# @t.route("/edit/confirm/", methods=['POST'])
# @login_required
# def transactionEditConfirm():
#     inputTID = request.form.get("tid")
#     return redirect(url_for("transaction.transactionHome"))


""" functions below are for transaction deletion """


@t.route("/edit/delete-landing", methods=['GET'])
@login_required
def transactionDelLanding():
    session['last'] = request.endpoint
    return render_template("delete.html", user=current_user)


@t.route('/fetch/by-tid', methods=['GET'])
@login_required
def fetchTransactionByID():  # deletion search
    try:
        userID = current_user.id
        tid = request.args.get("tid")
        transac = Transaction.query.filter_by(id=tid, user_id=userID).first()
        if (transac == None) or (transac == "None"):
            raise AttributeError(obj={'msg': "Transaction does not exist"})
    except ValueError as ve:
        flash(message=str(
            f"Invalid transation ID given. [{ve}]"), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    except AttributeError as ae:
        flash(message=str(
            f"Given transaction ID can't be found! [{ae.obj['msg']}]"), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    except Exception as e:
        flash(message="Unable to fetch transaction! <br> ERR:{}".format(
            e), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    # return jsonify({'id': transac.id, 'transaction': transac} if transac else {})
    if session['last']:
        if session['last'] == "transaction.transactionDelLanding":

            return render_template('delete.html', user=current_user, transaction=transac)
    else:
        # flash(request.endpoint)
        # return render_template('delete.html', user=current_user, transaction=transac)
        return 'hhh'


@t.route("/edit/delete", methods=['GET'])
@login_required
def transactionDel():  # delete transaction
    try:
        tid = str(request.args.get("tid"))
        tid = int(tid)
        delCon = request.args.get("delCon")
        userID = current_user.id
        if (delCon == None) or (delCon == "None"):
            raise confirmationError()
        else:
            result = Transaction.query.filter_by(
                id=tid, user_id=userID).first()
            if (result == None) or (result == "None"):
                raise AttributeError(obj={'msg': "Transaction does not exist"})
            db.session.delete(result)
            db.session.commit()
            flash('Transaction deleted!', category='success')
    except ValueError as ve:
        flash(message=str(
            f"Invalid transation ID given. [{ve}]"), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    except confirmationError:
        flash(message=str(
            "Unable to delete transaction! due to no user confirmation!"), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    except AttributeError as ae:
        flash(message=str(
            f"Given transaction ID can't be found! [{ae.obj['msg']}]"), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    except Exception as e:
        flash(message="Unable to delete transaction! <br> ERR:{}".format(
            e), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    return redirect(url_for("redirector.toTransactionHome"))


# """ functions below are for transaction modification """


# @t.route("/edit/delete-landing", methods=['GET'])
# @login_required
# def transactionDelLanding():
#     session['last'] = request.endpoint
#     return render_template("delete.html", user=current_user)


# @t.route('/fetch/by-tid', methods=['GET'])
# @login_required
# def fetchTransactionByID():  # deletion search
#     try:
#         userID = current_user.id
#         tid = request.args.get("tid")
#         transac = Transaction.query.filter_by(id=tid, user_id=userID).first()
#         if (transac == None) or (transac == "None"):
#             raise AttributeError(obj={'msg': "Transaction does not exist"})
#     except ValueError as ve:
#         flash(message=str(
#             f"Invalid transation ID given. [{ve}]"), category='error')
#         return redirect(url_for("redirector.toTransactionDel"))
#     except AttributeError as ae:
#         flash(message=str(
#             f"Given transaction ID can't be found! [{ae.obj['msg']}]"), category='error')
#         return redirect(url_for("redirector.toTransactionDel"))
#     except Exception as e:
#         flash(message="Unable to fetch transaction! <br> ERR:{}".format(
#             e), category='error')
#         return redirect(url_for("redirector.toTransactionDel"))
#     # return jsonify({'id': transac.id, 'transaction': transac} if transac else {})
#     if session['last']:
#         if session['last'] == "transaction.transactionDelLanding":

#             return render_template('delete.html', user=current_user, transaction=transac)
#     else:
#         # flash(request.endpoint)
#         # return render_template('delete.html', user=current_user, transaction=transac)
#         return 'hhh'


# @t.route("/edit/delete", methods=['GET'])
# @login_required
# def transactionDel():  # delete transaction
#     try:
#         tid = str(request.args.get("tid"))
#         tid = int(tid)
#         delCon = request.args.get("delCon")
#         userID = current_user.id
#         if (delCon == None) or (delCon == "None"):
#             raise confirmationError()
#         else:
#             result = Transaction.query.filter_by(
#                 id=tid, user_id=userID).first()
#             if (result == None) or (result == "None"):
#                 raise AttributeError(obj={'msg': "Transaction does not exist"})
#             db.session.delete(result)
#             db.session.commit()
#             flash('Transaction deleted!', category='success')
#     except ValueError as ve:
#         flash(message=str(
#             f"Invalid transation ID given. [{ve}]"), category='error')
#         return redirect(url_for("redirector.toTransactionDel"))
#     except confirmationError:
#         flash(message=str(
#             "Unable to delete transaction! due to no user confirmation!"), category='error')
#         return redirect(url_for("redirector.toTransactionDel"))
#     except AttributeError as ae:
#         flash(message=str(
#             f"Given transaction ID can't be found! [{ae.obj['msg']}]"), category='error')
#         return redirect(url_for("redirector.toTransactionDel"))
#     except Exception as e:
#         flash(message="Unable to delete transaction! <br> ERR:{}".format(
#             e), category='error')
#         return redirect(url_for("redirector.toTransactionDel"))
#     return redirect(url_for("redirector.toTransactionHome"))
