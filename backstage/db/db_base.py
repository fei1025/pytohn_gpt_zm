from sqlalchemy import create_engine, Column, Integer
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = "sqlite:///mydatabase.db"
engine = create_engine(DATABASE_URL,connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
#Base.metadata.create_all(bind=engine)


# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

class User_settings(Base):
    __tablename__ = "user_settings"
    id = Column(Integer, primary_key=True, index=True)
    # http_proxy = Column(String,default=None)
    # openai_api_key = Column(String,default=None)
    # llm = Column(String,default=None)
    # theme = Column(String,default=None)



