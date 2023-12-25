# Database schema
import datetime
import time

from flask_login import UserMixin, current_user, AnonymousUserMixin

from . import db


class User(db.Model, UserMixin, AnonymousUserMixin):
    """ Database table: user
        each user account setting/properties defined here.

        #Attribute:
            uname -> username (unique),\n
            fname -> firstname, \n
            alias -> alias (not null),\n
            password -> password, \n
            transactions -> relationship to `Transaction` table
        """
    __tablename__ = "user"
    id = db.Column(db.Integer(), unique=True, primary_key=True)
    uname = db.Column(db.String(26), unique=True)  # username
    fname = db.Column(db.String(56), default="[NONE].firstname")  # firstname
    alias = db.Column(db.String(20), default="[NONE].alias", nullable=False)
    password = db.Column(db.String())
    langPref = db.Column(db.String(2), default="EN")
    transactions = db.relationship("Transaction")

    def __str__(self):
        return self.fname

    @property
    def isMe(self) -> bool:
        if not current_user.is_authenticated:
            # return current_app.login_manager.unauthorized()
            return False
        elif current_user.is_authenticated and (current_user.fname == 'KITTIPICH'):
            return True
        return False

    # Should be implemented with cookie or session instead
    # def setLang(self, lang:str="EN"): # "TH" || "EN"
    #     if (lang != "EN" or lang != "TH"):
    #         self.fname = "EN"
    #     self.langPref = lang

    # @property
    # def getLangPref(self):
    #     return self.langPref


class SignupCode(db.Model):
    """ Database table: signup_code
        list of single use signup code

        #Attribute:
            code -> signup code (unique),\n
            isused -> is used, \n

        """
    __tablename__ = "signupCode"
    id = db.Column(db.Integer(), unique=True, primary_key=True)
    code = db.Column(db.String(9), default=False, unique=True)
    isused = db.Column(db.Boolean, default=False)

class Transaction(db.Model):
    """ Database table: transaction
        list of single use signup code

        #Attribute:
            typee -> spend, exchange, receive, owe, \n
            amount -> transaction amount, \n
            currency -> THB, etc., \n
            via -> transaction method (cash, etc), \n
            party -> receiver or payer name (if user is payer than party is receiver), \n
            location -> name of a place that the transaction is taken, \n
            country -> country/region that the transaction is taken (ISO 3166-1 alpha-3 country code), \n
            dtime -> date and time of the transaction is processed, \n
            notes -> transaction notes, \n
            user_id -> foreign key to user

        """
    __tablename__ = "transaction"
    id = db.Column(db.Integer(), unique=True, primary_key=True)
    amount = db.Column(db.Float(), nullable=False)
    currency = db.Column(db.String(3), nullable=False, default="THB")
    via = db.Column(db.String(30), nullable=False, default="cash")
    party = db.Column(db.String(30), nullable=False)
    location = db.Column(db.String(56), nullable=False, default="unspecified")
    notes = db.Column(db.String(100), nullable=True)
    dtime = db.Column(db.String(18))
    country = db.Column(db.String(5)) # THA
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    typee = db.Column(db.String(20), nullable=False)


    