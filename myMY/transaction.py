""" transaction """
from flask import Blueprint, redirect, url_for, render_template, flash, request, Response, jsonify, session
from flask_login import login_required, current_user
from .models import Transaction
from myMY import db
from .customErrorClass import confirmationError
from datetime import datetime, timezone, timedelta
from .idGen import gen1
from .totalCal import totalCal
import requests as rq
# from builtins import ty

t = Blueprint("transaction", __name__)

@t.route("/home/", methods=['GET'])
@login_required
def transactionHome():
    return render_template("transaction.html", user=current_user)

@t.route("/get/", methods=['GET'])
@login_required
def transactionGet():
    # Specify the UTC offset for Bangkok (UTC+7)
    bkk_timezone_offset = timedelta(hours=7)
    # Create a timezone object for Bangkok
    bkk_timezone = timezone(bkk_timezone_offset)
    # Get the current time in Bangkok timezone
    bkk_time = datetime.now(bkk_timezone)
    # Format the time string
    t = bkk_time.strftime("%Y-%m-%d @%H:%M:%S [GMT+7]")
    g = Transaction.query.filter_by(user_id=current_user.id).all()
    try:
        t = session['LCT']
    except:
        pass
    totalAmount = totalCal()
    itemsAmount = g.__len__() # amount of the queried transactions

    return render_template("get.html", user=current_user, get=g, total=None, time=t)

@t.route("/edit/delete-landing", methods=['GET'])
@login_required
def transactionDelLanding():
    session['last'] = request.endpoint
    return render_template("delete.html", user=current_user)

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


@t.route("/edit/delete", methods=['GET'])
@login_required
def transactionDel():
    try:
        tid = str(request.args.get("tid"))
        tid = int(tid)
        delCon = request.args.get("delCon")
        userID = current_user.id
        if (delCon == None) or (delCon == "None"):
            raise confirmationError()
        else:
            result = Transaction.query.filter_by(id=tid,user_id=userID).first()
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


@t.route("/export/", methods=['GET'])
@login_required
def exportAsPdf():
    try:
        data = Transaction.query.filter_by(user_id=current_user.id).all()
    except Exception as e:
        flash(e)
    csv_data = str()
    for i in range(len(data)):
        pairs = list(data[i].__dict__.items()) # convert the list of key value pairs into a list
        keys = list(data[i].__dict__.keys()) # convert the list of keys into a list
        values = list(data[i].__dict__.values()) # convert the list of value into a list
        for ii in range(len(keys)):
            # csv_data += '\n'.join(keys[ii], values[ii])
            pair = pairs[i+1] if i == 0 else i
            key = keys[i+1] if i == 0 else i
            value = values[i+1]if i == 0 else i
            # flash(f"{pair}->{key} : {value}")
            csv_data +=  str(key) + ":" + str(value)
            flash(csv_data)
    # fn= gen1()
    # flash(csv_data)

    # response = Response(
    #     csv_data,
    #     content_type='text/csv',
    #     headers={'Content-Disposition': 'attachment; filename={}.csv'.format(fn)}
    # )

    
    return render_template('root.html', user=current_user)

@t.route('/fetch/by-tid', methods=['GET'])
@login_required
def fetchTransactionByID():
    try:
        userID = current_user.id
        tid = request.args.get("tid")
        transac = Transaction.query.filter_by(id=tid,user_id=userID).first()
        if (transac == None) or (transac == "None"):
            raise AttributeError(obj={'msg':"Transaction does not exist"})
    except ValueError as ve:
        flash(message=str(f"Invalid transation ID given. [{ve}]"), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    except AttributeError as ae:
        flash(message=str(f"Given transaction ID can't be found! [{ae.obj['msg']}]"), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    except Exception as e:
        flash(message="Unable to fetch transaction! <br> ERR:{}".format(e), category='error')
        return redirect(url_for("redirector.toTransactionDel"))
    # return jsonify({'id': transac.id, 'transaction': transac} if transac else {})
    if session['last']:
        if session['last'] == "transaction.transactionDelLanding":
        
            return render_template('delete.html', user=current_user, transaction=transac)
    else:
        # flash(request.endpoint)
        # return render_template('delete.html', user=current_user, transaction=transac)
        return 'hhh'
