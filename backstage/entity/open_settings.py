from tokenize import String

from sqlalchemy import Column, Integer

from db.db_base import Base

'''
Integer: 这是字段的数据类型，表示这个字段将存储整数类型的数据。

primary_key=True: 这是一个参数，指示该字段是表的主键，即它的值在表中是唯一的，用于标识每行数据的唯一性。主键通常用于唯一地标识表中的每个记录。

index=True: 这是一个参数，指示这个字段应该被索引。索引可以加速数据库查询，特别是在需要根据该字段进行搜索或过滤的情况下。索引可以显著提高数据库查询性能。
'''
# 创建模型
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, index=True)
    email = Column(String, unique=True, index=True)