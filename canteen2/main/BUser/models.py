from main.database import Base

from sqlalchemy import Column, Integer, String, Date, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship

from werkzeug import generate_password_hash
from werkzeug.security import gen_salt

import datetime


class User(Base):
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True)
    real_name = Column(String)
    username = Column(String, unique=True, nullable=False)
    password = Column(String, nullable=False)
    email = Column(String, nullable=False)
    timestamp_created = Column(
        DateTime, nullable=False, default=datetime.datetime.utcnow())
    timestamp_modified = Column(DateTime)

    orders = relationship('Order', backref='user')

    def __init__(self, username, password, email, real_name=""):
        self.real_name = real_name
        self.username = username
        self.password = generate_password_hash(str(password).encode())
        self.email = email
        self.timestamp_modified = datetime.datetime.utcnow()

    def __repr__(self):
        return '<User {0}>'.format(self.username)


class Token(Base):
    __tablename__ = 'token'
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('user.id', ondelete='CASCADE'))
    token = Column(String(40))
    expires = Column(DateTime)

    user = relationship('User')

    def __init__(self, user_id):
        self.user_id = user_id
        self.token = self.generate_token()
        self.expires = self.calc_expire_date()

    @staticmethod
    def generate_token():
        return gen_salt(40)

    @staticmethod
    def calc_expire_date():
        _date = datetime.datetime.utcnow() + datetime.timedelta(3)

        return _date

    def is_expired(self):
        return self.expires < datetime.datetime.utcnow()

    def __repr__(self):
        return "<Token {0} for user {1}>".format(self.id, self.user_id)
