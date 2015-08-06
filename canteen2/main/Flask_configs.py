import os

USER = os.environ['DB_ENV_POSTGRES_USER']
PASS = os.environ['DB_ENV_POSTGRES_PASSWORD']
TABLE_NAME = USER


class Config():
    SECRET_KEY = "UX\x97\xc7\xd2\xf4\xa1Xf\xdc\xbeuSM\x9b"
    SALT = "\x85\x88\xf8\x9e\xf5K\xc8O\xebe\xbc'zlz"
    SQLALCHEMY_DATABASE_URI = 'postgresql://{0}:{1}@db/{2}'.format(USER, PASS, TABLE_NAME)


class DevConfig(Config):
    DEBUG = True


class TestConfig(DevConfig):
    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + \
        os.path.join(os.getcwd(), 'canteen.db')
