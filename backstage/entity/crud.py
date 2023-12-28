import time
from typing import List

from sqlalchemy.orm import Session

from Util import cacheUtil
from entity import models, schemas

userKey = "userSetting";


def get_user(db: Session, user_id: int):
    return db.query(models.User).filter(models.User.id == user_id).first()


def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()


def get_users(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.User).offset(skip).limit(limit).all()


def create_user(db: Session, user: schemas.UserCreate):
    fake_hashed_password = user.password + "notreallyhashed"
    db_user = models.User(email=user.email, hashed_password=fake_hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def get_items(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Item).offset(skip).limit(limit).all()


def create_user_item(db: Session, item: schemas.ItemCreate, user_id: int):
    db_item = models.Item(**item.dict(), owner_id=user_id)
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item


# 获取用户的设置
def get_user_setting(db: Session) -> models.User_settings:
    setting = db.query(models.User_settings).filter(models.User_settings.id == 1).first()
    return setting


# 用户设置应该有一个,且只有一个
def save_user_setting(db: Session, userSettings: models.User_settings):
    setting = db.query(models.User_settings).filter(models.User_settings.id == 1).first()
    if setting is None:
        userSettings.id = 1
        db.add(userSettings)
        db.commit()
        db.refresh(userSettings)
    else:
        # db.query(models.User_settings).filter(models.User_settings.id == 1).update(userSettings)
        if userSettings.theme and len(userSettings.theme) > 0:
            setting.theme = userSettings.theme
        if userSettings.http_proxy and len(userSettings.http_proxy) > 0:
            setting.http_proxy = userSettings.http_proxy
        if userSettings.openai_api_key and len(userSettings.openai_api_key) > 0:
            setting.openai_api_key = userSettings.openai_api_key
        if userSettings.openai_api_base and len(userSettings.openai_api_base) > 0:
            setting.openai_api_base = userSettings.openai_api_base
        if userSettings.llm and len(userSettings.llm) > 0:
            setting.llm = userSettings.llm
        if userSettings.wolfram_appid and len(userSettings.wolfram_appid) > 0:
            setting.wolfram_appid = userSettings.wolfram_appid
        if userSettings.model and len(userSettings.model) > 0:
            setting.model = userSettings.model
        db.commit()
    cacheUtil.ca_save(userKey, setting)


def save_chat_hist(db: Session, chatHist: models.chat_hist):
    setting = get_user_setting(db)
    # 使用设置的默认model
    if setting.model:
        chatHist.model = setting.model
    else:
        chatHist.model = "0"
    db.add(chatHist)
    db.commit()
    db.refresh(chatHist)


def update_chat(db: Session, chatHist: models.chat_hist):
    chat_hist = db.query(models.chat_hist).filter(models.chat_hist.chat_id == chatHist.chat_id).first()
    if chatHist.model:
        chat_hist.model = chatHist.model
    if chatHist.title:
        chat_hist.title = chatHist.title


def save_chat_hist_details(db: Session, chatHistDetails: models.chat_hist_details):
    db.add(chatHistDetails)
    db.commit()
    db.refresh(chatHistDetails)


def get_all_Hist(db: Session):
    return db.query(models.chat_hist).all()


def get_chat_hist_details(db: Session, chatId: str) -> List[models.chat_hist_details]:
    return db.query(models.chat_hist_details).filter(models.chat_hist_details.chat_id == chatId).all()


def delete_chat(db: Session, chatId: str):
    db.query(models.chat_hist_details).filter(models.chat_hist_details.chat_id == chatId).delete()
    db.query(models.chat_hist).filter(models.chat_hist.chat_id == chatId).delete()
    db.commit()


def delete_all_chat(db: Session):
    db.query(models.chat_hist_details).delete()
    db.query(models.chat_hist).delete()
    db.commit()


def save_knowledge(db: Session, knowledge: models.knowledge):
    db.add(knowledge)
    db.commit()
    db.refresh(knowledge)


def get_knowledge(db: Session, knowledge: models.knowledge) -> models.knowledge:
    return db.query(models.knowledge).filter(models.knowledge.id == knowledge.id)
