import time
from datetime import datetime

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
    # 代理地址
    http_proxy = Column(String, default=None)
    # openAi 的key
    openai_api_key = Column(String, default=None)
    # openAi的转发地址
    openai_api_base = Column(String, default=None)
    # 默认openAI
    llm = Column(String, default=None)
    # 当前主题
    theme = Column(String, default=None)
    # wolfram 的appid
    wolfram_appid = Column(String, default=None)
    # 新建聊天默认model
    model = Column(String)


class chat_hist(Base):
    __tablename__ = "chat_hist"
    chat_id = Column(Integer, primary_key=True, autoincrement=True, index=True)
    title = Column(String, index=True)
    creation_time = Column(Date, default=datetime.now())
    model = Column(String)
    type = Column(String)
    knowledge_id = Column(String)
    tools = Column(String)

class chat_hist_details(Base):
    __tablename__ = "chat_hist_details"
    id = Column(Integer, primary_key=True, autoincrement=True, index=True)
    chat_id = Column(Integer, default=None)
    other_data= Column(String, default=None,comment="其他备注数据")
    role = Column(String, default=None)
    content = Column(String, default=None)
    token_num = Column(String, default=None)
    creation_time = Column(Date, default=datetime.now())
    toolList = []
    other_data_list=[]


class chat_hist_details_tools(Base):
    __tablename__ = "chat_hist_details_tools"
    id = Column(Integer, primary_key=True, autoincrement=True, index=True)
    chat_details_id = Column(Integer, default=None)
    type = Column(String,comment="类型数据")
    tools = Column(String)
    problem=Column(String,comment="向工具提问的问题")
    tool_data= Column(String,comment="工具返回的数据,根据类型走")
    creation_time = Column(Date, default=datetime.now())



class knowledge(Base):
    __tablename__ = "knowledge_info"
    id = Column(Integer, primary_key=True, autoincrement=True, index=True)
    knowledge_name = Column(String, default=None, comment="知识库的名字")
    file_path = Column(String, default=None, comment="文件路径")
    file_summarize = Column(String, default=None, comment="文章总结")
    index_name = Column(String, default=None, comment="索引名称")
    index_path = Column(String, default=None, comment="索引名称")


class knowledge_file(Base):
    __tablename__ = "knowledge_file"
    id = Column(Integer, primary_key=True, autoincrement=True, index=True)
    knowledge_id = Column(String, default=None, comment="主表id")
    content_md5 = Column(String, default=None, comment="文件md5")
    file_name = Column(String, default=None, comment="文件名字")
    file_path = Column(String, default=None, comment="文件路径")
