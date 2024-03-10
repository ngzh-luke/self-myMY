# transactions exporter
from flask_login import login_required, current_user
from flask import flash, render_template, request, Blueprint, Response, abort, session
from pandas import DataFrame as df
from .models import Transaction
from .idGen import gen1
from .customErrorClass import noTransactionsError

tx = Blueprint("tx", __name__)


@tx.route('/', methods=['GET'])
@login_required
def exportLanding():
    return render_template('export.html', user=current_user)


@tx.route("/export/pdf", methods=['GET'])
@login_required
def exportAsPdf():
    try:
        data = Transaction.query.filter_by(user_id=current_user.id).all()
    except Exception as e:
        flash(e)
    csv_data = str()
    for i in range(len(data)):
        # convert the list of key value pairs into a list
        pairs = list(data[i].__dict__.items())
        # convert the list of keys into a list
        keys = list(data[i].__dict__.keys())
        # convert the list of value into a list
        values = list(data[i].__dict__.values())
        for ii in range(len(keys)):
            # csv_data += '\n'.join(keys[ii], values[ii])
            pair = pairs[i+1] if i == 0 else i
            key = keys[i+1] if i == 0 else i
            value = values[i+1]if i == 0 else i
            # flash(f"{pair}->{key} : {value}")
            csv_data += str(key) + ":" + str(value)
            flash(csv_data)
    # fn= gen1()
    # flash(csv_data)

    # response = Response(
    #     csv_data,
    #     content_type='text/csv',
    #     headers={'Content-Disposition': 'attachment; filename={}.csv'.format(fn)}
    # )

    return render_template('export.html', user=current_user)


@tx.route("/csv", methods=['GET'])
@login_required
def exportAsCSV():
    session['last'] = request.endpoint
    TABLE_NAME = "Transactions"
    NOBE = '_sa_instance_state'
    NOBE2 = 'user_id'
    COL_NAME = ['ID', 'VIA', 'DATE&TIME', 'TYPE', 'AMOUNT',
                'CURRENCY', 'PARTY', 'LOCATION', 'COUNTRY/REGION', 'NOTES']
    ft = request.args.get("filter")
    match ft:
        # ?filter=all
        case 'all':
            try:
                data = Transaction.query.filter_by(
                    user_id=current_user.id).all()
                if len(data) == 0:
                    raise noTransactionsError()

                # get table columns of the query
                keys = list(data[0].__dict__.keys())
                keys.remove(NOBE)  # remove unnecessary column
                keys.remove(NOBE2)
                # for ii in range(len(keys)):
                #     if len(colname)/len(keys) != 1:
                #             colname.append(keys[ii])

            except noTransactionsError:
                flash(message=str(
                    "Unable to export due to no transaction records!"), category='error')
                return render_template('export.html', user=current_user)
            except Exception as e:
                flash(e, category='error')
                return render_template('export.html', user=current_user)
            try:
                fn = TABLE_NAME + "-all_" + gen1()
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
        # ?filter=income
        case 'income':
            try:
                data = Transaction.query.filter_by(
                    user_id=current_user.id, typee='income').all()
                if len(data) == 0:
                    raise noTransactionsError()

                # get table columns of the query
                keys = list(data[0].__dict__.keys())
                keys.remove(NOBE)  # remove unnecessary column
                keys.remove(NOBE2)

            except noTransactionsError:
                flash(message=str(
                    "Unable to export due to no transaction records!"), category='error')
                return render_template('export.html', user=current_user)
            except Exception as e:
                flash(e, category='error')
                return render_template('export.html', user=current_user)
            try:
                fn = TABLE_NAME + "-income_" + gen1()
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
        # ?filter=outcome
        case 'outcome':
            try:
                data = Transaction.query.filter_by(
                    user_id=current_user.id, typee='outcome').all()
                if len(data) == 0:
                    raise noTransactionsError()

                # get table columns of the query
                keys = list(data[0].__dict__.keys())
                keys.remove(NOBE)  # remove unnecessary column
                keys.remove(NOBE2)

            except noTransactionsError:
                flash(message=str(
                    "Unable to export due to no transaction records!"), category='error')
                return render_template('export.html', user=current_user)
            except Exception as e:
                flash(e, category='error')
                return render_template('export.html', user=current_user)
            try:
                fn = TABLE_NAME + "-outcome_" + gen1()
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
        # ?filter=donate
        case 'donate':
            try:
                data = Transaction.query.filter_by(
                    user_id=current_user.id, typee='donate').all()
                if len(data) == 0:
                    raise noTransactionsError()

                # get table columns of the query
                keys = list(data[0].__dict__.keys())
                keys.remove(NOBE)  # remove unnecessary column
                keys.remove(NOBE2)

            except noTransactionsError:
                flash(message=str(
                    "Unable to export due to no transaction records!"), category='error')
                return render_template('export.html', user=current_user)
            except Exception as e:
                flash(e, category='error')
                return render_template('export.html', user=current_user)
            try:
                fn = TABLE_NAME + "-donate_" + gen1()
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
        # ?filter=invest
        case 'invest':
            try:
                data = Transaction.query.filter_by(
                    user_id=current_user.id, typee='invest').all()
                if len(data) == 0:
                    raise noTransactionsError()

                # get table columns of the query
                keys = list(data[0].__dict__.keys())
                keys.remove(NOBE)  # remove unnecessary column
                keys.remove(NOBE2)

            except noTransactionsError:
                flash(message=str(
                    "Unable to export due to no transaction records!"), category='error')
                return render_template('export.html', user=current_user)
            except Exception as e:
                flash(e, category='error')
                return render_template('export.html', user=current_user)
            try:
                fn = TABLE_NAME + "-invest_" + gen1()
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
        # ?filter=deposit
        case 'deposit':
            try:
                data = Transaction.query.filter_by(
                    user_id=current_user.id, typee='deposit').all()
                if len(data) == 0:
                    raise noTransactionsError()

                # get table columns of the query
                keys = list(data[0].__dict__.keys())
                keys.remove(NOBE)  # remove unnecessary column
                keys.remove(NOBE2)

            except noTransactionsError:
                flash(message=str(
                    "Unable to export due to no transaction records!"), category='error')
                return render_template('export.html', user=current_user)
            except Exception as e:
                flash(e, category='error')
                return render_template('export.html', user=current_user)
            try:
                fn = TABLE_NAME + "-deposit_" + gen1()
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
        # ?filter=withdrawal
        case 'withdrawal':
            try:
                data = Transaction.query.filter_by(
                    user_id=current_user.id, typee='withdrawal').all()
                if len(data) == 0:
                    raise noTransactionsError()

                # get table columns of the query
                keys = list(data[0].__dict__.keys())
                keys.remove(NOBE)  # remove unnecessary column
                keys.remove(NOBE2)

            except noTransactionsError:
                flash(message=str(
                    "Unable to export due to no transaction records!"), category='error')
                return render_template('export.html', user=current_user)
            except Exception as e:
                flash(e, category='error')
                return render_template('export.html', user=current_user)
            try:
                fn = TABLE_NAME + "-withdrawal_" + gen1()
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
        # ?filter=transfer
        case 'transfer':
            try:
                data = Transaction.query.filter_by(
                    user_id=current_user.id, typee='transfer').all()
                if len(data) == 0:
                    raise noTransactionsError()

                # get table columns of the query
                keys = list(data[0].__dict__.keys())
                keys.remove(NOBE)  # remove unnecessary column
                keys.remove(NOBE2)

            except noTransactionsError:
                flash(message=str(
                    "Unable to export due to no transaction records!"), category='error')
                return render_template('export.html', user=current_user)
            except Exception as e:
                flash(e, category='error')
                return render_template('export.html', user=current_user)
            try:
                fn = TABLE_NAME + "-transfer_" + gen1()
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
        # any other received value
        case _:
            flash(
                message="Unable to export due to unsupported transaction type!", category='error')
            return render_template('export.html', user=current_user)
    # without arg or any other
    return abort(404)
