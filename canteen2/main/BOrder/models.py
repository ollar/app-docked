from main.database import Base
from sqlalchemy import Column, Integer, String, Date, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
import datetime


class Order(Base):
    __tablename__ = 'order'
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('user.id', ondelete='CASCADE'))
    order_date = Column(Date)
    meal_id = Column(Integer, ForeignKey('meal.id', ondelete='SET NULL'))
    quantity = Column(Integer, default=1, nullable=False)
    timestamp_created = Column(
        DateTime, default=datetime.datetime.utcnow(), nullable=False)
    timestamp_modified = Column(DateTime)

    meal = relationship('Meal')

    def __init__(self, order_date, meal_id, user_id, quantity):
        self.user_id = user_id
        self.order_date = order_date
        self.meal_id = meal_id
        self.quantity = quantity
        self.timestamp_modified = datetime.datetime.utcnow()

    def __repr__(self):
        return '<Order: {0} by {1}>'.format(self.order_date, self.user_id)
