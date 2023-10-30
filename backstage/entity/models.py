from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, Date
from sqlalchemy.orm import relationship

from db.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default=True)

    items = relationship("Item", back_populates="owner")


class Item(Base):
    __tablename__ = "items"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(String, index=True)
    owner_id = Column(Integer, ForeignKey("users.id"))
    owner = relationship("User", back_populates="items")


class User_settings(Base):
    __tablename__ = "user_settings"
    id = Column(Integer, primary_key=True, index=True)
    http_proxy = Column(String, default=None)
    openai_api_key = Column(String, default=None)
    llm = Column(String, default=None)
    theme = Column(String, default=None)
    # wolfram 的appid
    wolfram_appid = Column(String, default=None)



class chat_hist(Base):
    __tablename__ = "chat_hist"
    chat_id = Column(String, primary_key=True, index=True)


class chat_hist_details(Base):
    __tablename__ = "chat_hist_details"
    id = Column(Integer, primary_key=True, index=True)
    chat_id = Column(String, default=None)
    role = Column(String, default=None)
    content = Column(String, default=None)
    token_num = Column(String, default=None)
    creation_time = Column(Date, default=None)
