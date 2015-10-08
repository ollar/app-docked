import os

USER = os.environ['DB_ENV_POSTGRES_USER']
PASS = os.environ['DB_ENV_POSTGRES_PASSWORD']
TABLE_NAME = USER

SALT = os.environ['SALT']
SECRET_KEY = os.environ['SECRET_KEY']

class Config():
    SECRET_KEY = SECRET_KEY
    SALT = SALT
    SQLALCHEMY_DATABASE_URI = 'postgresql://{0}:{1}@db/{2}'.format(USER, PASS, TABLE_NAME)
    JSONIFY_PRETTYPRINT_REGULAR = False


class DevConfig(Config):
    DEBUG = True


class TestConfig(DevConfig):
    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + \
        os.path.join(os.getcwd(), 'canteen.db')
