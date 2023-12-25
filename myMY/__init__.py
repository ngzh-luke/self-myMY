# Root file of the system
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_login import LoginManager, current_user
from flask import Flask, Blueprint, render_template, abort, flash, session, redirect, request, url_for
from flask_migrate import Migrate
from decouple import config as en_var  # import the environment var
from datetime import timedelta
db = SQLAlchemy()
migrate = Migrate()
DB_NAME = en_var(
    'DATABASE_URL', "sqlite:///myMY_db.sqlite")
TIMEOUT = timedelta(hours=3)
try:
    PORT = en_var("port")
except:
    PORT = 5500

DOMAIN = en_var('server', f"indev.lukecreated.com:{PORT}")


def createApp():
    app = Flask(__name__)
    f_bcrypt = Bcrypt()
    app.config['FLASK_ADMIN-SWATCH'] = 'cerulean'
    # Encrepted with Environment Variable
    app.config['SECRET_KEY'] = en_var('myMY', 'myMY_secret')
    app.config['DATABASE_NAME'] = DB_NAME
    app.config['SQLALCHEMY_DATABASE_URI'] = f'{DB_NAME}'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['REMEMBER_COOKIE_SECURE'] = True
    # set session timeout (need to use with before_request() below)
    app.config['PERMANENT_SESSION_LIFETIME'] = TIMEOUT
    app.config['TIMEZONE'] = 'Asia/Bangkok'
    # app.config['SERVER_NAME'] = DOMAIN

    f_bcrypt.init_app(app)
    db.init_app(app)
    migrate.init_app(app, db)

    from .transaction import t
    from .authen import iden
    from .redirector import r
    from .account import acc
    app.register_blueprint(rootView, url_prefix='/')
    app.register_blueprint(t, url_prefix='/transaction')
    app.register_blueprint(iden, url_prefix='/iden-operation')
    app.register_blueprint(r, url_prefix='/')
    app.register_blueprint(acc, url_prefix='/account')
    app.register_error_handler(404, notFound)

    # with app.app_context(): # Drop all of the tables
    #     db.drop_all()

    try:
        with app.app_context():
            db.create_all()
    except Exception as e:
        db.session.rollback()
        flash(f'{e}', category='error')
        print(f"Error: {e}")

    from .models import User

    # config the user session
    @app.before_request
    def before_request():
        session.permanent = True
        # session.modified = True # default set to true. Consult the lib to confirm

    login_manager = LoginManager()
    login_manager.login_view = 'auth.login'
    login_manager.refresh_view = 'auth.login'
    login_manager.login_message_category = 'info'
    login_manager.needs_refresh_message_category = "info"
    login_manager.needs_refresh_message = "You have to login again to confirm your identity!"
    login_manager.init_app(app)

    @login_manager.user_loader
    def load_user(id):
        return User.query.get(int(id))

    return app


class About():
    version = float()
    status = str()
    build = int()
    version_note = str()

    def __init__(self, version: float = float(0.0), status: str = 'None Stated', build: int = 20231200, version_note: str = "None Stated"):
        self.version = version
        self.status = status
        self.build = build
        self.version_note = version_note

    def __str__(self) -> str:
        return str("{ " + f"Version: {self.version} | Status: {self.status} | Build: {self.build} | Updates: {self.version_note}" + " }")

    def getSystemVersion(self) -> str:
        return str(self.version)


systemInfoObject = About(version=0.491, status='Beta Release',
                         build=20231226, version_note='Transaction DB model adjustment + add migration')
systemInfo = systemInfoObject.__str__()
systemVersion = systemInfoObject.getSystemVersion()

rootView = Blueprint('rootView', __name__)


@rootView.route("/dev/root-template-view/")
def root_View():
    if not current_user.is_authenticated:
        abort(401)  # unauthorized
    elif current_user.isMe == True:
        return render_template("root.html", user=current_user)
    else:
        abort(403)  # forbidden


@rootView.route("/about/")
def aboutView():
    return render_template("about.html", user=current_user, version=systemVersion,versionNotes=systemInfoObject.version_note,build=systemInfoObject.build,status=systemInfoObject.status )

# handle not found
def notFound(e):
    """ not found 404 """
    return render_template('404.html', path=request.full_path)
