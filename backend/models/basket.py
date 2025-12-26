from sqlalchemy import Column, Integer, String, Text

from database.session import Base


class Basket(Base):
    __tablename__ = "baskets"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    tags = Column(String(255), nullable=True)
