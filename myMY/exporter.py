# transactions exporter
from flask_login import login_required, current_user
from flask import flash, render_template, request, Blueprint, Response, session
from pandas import DataFrame as df
from .models import Transaction
from .idGen import gen1
from .customErrorClass import noTransactionsError

tx = Blueprint("tx", __name__)


@tx.get('/')
@login_required
def exportLanding():
    return render_template('export.html', user=current_user)


@tx.get("/csv")
@login_required
def exportAsCSV():
    session['last'] = request.endpoint
    TABLE_NAME = "Transactions"
    NOBES = ['_sa_instance_state', 'user_id']
    COL_NAME = ['ID', 'VIA', 'DATE&TIME', 'TYPE', 'AMOUNT',
                'CURRENCY', 'PARTY', 'LOCATION', 'COUNTRY/REGION', 'NOTES']
    TYPES = ['income', 'outcome', 'donate', 'invest', 'transfer',
             'owe', 'exchange', 'deposit', 'withdrawal', 'refund']
    PLACES = ['THA', 'CHN', 'TWN', 'USA', '___']
    ft = request.args.get("type")
    fp = request.args.get('place')
    
    # export by transaction type or export all transactions
    if ft in TYPES or ft == 'all':
        try:
            a = True
            if ft =='all':
                data = Transaction.query.filter_by(
                user_id=current_user.id).all()
            else:
                a = False
                data = Transaction.query.filter_by(
                user_id=current_user.id, typee=TYPES[TYPES.index(ft)]).all()
            if len(data) == 0:
                raise noTransactionsError()

            # get table columns of the query
            keys = list(data[0].__dict__.keys())
            keys.remove(NOBES[0])  # remove unnecessary column
            keys.remove(NOBES[1])

        except noTransactionsError:
            flash(message=str(
                "Unable to export due to no transaction records!"), category='error')
            return render_template('export.html', user=current_user)
        except Exception as e:
            flash(e, category='error')
            return render_template('export.html', user=current_user)
        try:
            fn = TABLE_NAME + f"-{TYPES[TYPES.index(ft)]}_" + gen1() if a == False else TABLE_NAME + "-all_" + gen1() 
            frame = df(columns=COL_NAME, data={

                COL_NAME[0]: [str(data[v].id) for v in range(len(data))],
                COL_NAME[1]: [str(data[v].via) for v in range(len(data))],
                COL_NAME[2]: [str(data[v].dtime) for v in range(len(data))],
                COL_NAME[3]: [str(data[v].typee) for v in range(len(data))],
                COL_NAME[4]: [str(data[v].amount) for v in range(len(data))], COL_NAME[5]: [str(data[v].currency) for v in range(len(data))],
                COL_NAME[6]: [str(data[v].party) for v in range(len(data))],
                COL_NAME[7]: [str(data[v].location) for v in range(len(data))], COL_NAME[8]: [str(data[v].country) for v in range(len(data))],
                COL_NAME[9]: [str(data[v].notes) for v in range(len(data))]
            })
            frame.index += 1  # start index at 1
            csv_data = frame.to_csv(
                na_rep="N/A", header=COL_NAME, sep=',', index=True, index_label="NO.")

            response = Response(
                csv_data,
                content_type='text/csv',
                headers={
                    'Content-Disposition': 'attachment; filename={}.csv'.format(fn)}
            )
        except Exception as e:
            response = render_template('export.html', user=current_user)
            flash(message=e, category='error')
        return response
    elif fp in PLACES:  # export by transaction place
        try:
           
            data = Transaction.query.filter_by(
            user_id=current_user.id, country=PLACES[PLACES.index(fp)]).all()
            if len(data) == 0:
                raise noTransactionsError()

            # get table columns of the query
            keys = list(data[0].__dict__.keys())
            keys.remove(NOBES[0])  # remove unnecessary column
            keys.remove(NOBES[1])
        
        except noTransactionsError:
            flash(message=str(
                "Unable to export due to no transaction records!"), category='error')
            return render_template('export.html', user=current_user)
        except Exception as e:
            flash(e, category='error')
            return render_template('export.html', user=current_user)
        try:
            fn = TABLE_NAME + f"-{PLACES[PLACES.index(fp)]}_" + gen1()
            frame = df(columns=COL_NAME, data={

                COL_NAME[0]: [str(data[v].id) for v in range(len(data))],
                COL_NAME[1]: [str(data[v].via) for v in range(len(data))],
                COL_NAME[2]: [str(data[v].dtime) for v in range(len(data))],
                COL_NAME[3]: [str(data[v].typee) for v in range(len(data))],
                COL_NAME[4]: [str(data[v].amount) for v in range(len(data))], COL_NAME[5]: [str(data[v].currency) for v in range(len(data))],
                COL_NAME[6]: [str(data[v].party) for v in range(len(data))],
                COL_NAME[7]: [str(data[v].location) for v in range(len(data))], COL_NAME[8]: [str(data[v].country) for v in range(len(data))],
                COL_NAME[9]: [str(data[v].notes) for v in range(len(data))]
            })
            frame.index += 1  # start index at 1
            csv_data = frame.to_csv(
                na_rep="N/A", header=COL_NAME, sep=',', index=True, index_label="NO.")

            response = Response(
                csv_data,
                content_type='text/csv',
                headers={
                    'Content-Disposition': 'attachment; filename={}.csv'.format(fn)}
            )
        except Exception as e:
            response = render_template('export.html', user=current_user)
            flash(message=e, category='error')
        return response
    # without arg or any other
    else:
        flash(
            message="Unable to export due to invalid arguments!", category='error')
        return render_template('export.html', user=current_user)
