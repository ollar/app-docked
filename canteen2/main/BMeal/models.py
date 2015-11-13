from main.database import Base
from sqlalchemy import Column, Integer, String, Date, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
import datetime


class Meal(Base):
    __tablename__ = 'meal'
    id = Column(Integer, primary_key=True)
    title = Column(String)
    description = Column(String)
    category = Column(Integer)
    day_linked = Column(Integer)
    source_price = Column(Integer, nullable=False)
    price = Column(Integer, nullable=False)
    enabled = Column(Boolean, default=True)
    timestamp_created = Column(
        DateTime, default=datetime.datetime.utcnow(), nullable=False)
    timestamp_modified = Column(DateTime)

    def __init__(self, title, description, category, day_linked, enabled=1, source_price=0, price=0, *args, **kwargs):
        self.title = title
        self.description = description
        self.category = category
        self.day_linked = day_linked
        self.source_price = source_price
        self.price = price
        self.enabled = enabled
        self.timestamp_modified = datetime.datetime.utcnow()

    def __repr__(self):
        return '<Meals {0}>'.format(self.title)
