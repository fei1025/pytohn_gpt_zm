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


# 开始用户数据
def get_user_setting(db: Session) ->models.User_settings :
    setting = cacheUtil.calculate_value(userKey)
    if setting is None:
        setting = db.query(models.User_settings).filter(models.User_settings.id == 1).first()
        if setting is None:
            setting = models.User_settings(id=1)
            db.add(setting)
            db.commit()
            db.refresh(setting)
            cacheUtil.ca_save(userKey, setting);
            return setting
        else:
            cacheUtil.ca_save(userKey, setting);
            return setting
    else:
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
        db.query(models.User_settings).filter(models.User_settings.id == 1).update(userSettings)
    cacheUtil.ca_save(userKey, userSettings)


def save_chat_hist(db: Session, chatHist: models.chat_hist):
    db.add(chatHist)
    db.commit()
    db.refresh(chatHist)


def save_chat_hist_details(db: Session, chatHistDetails: models.chat_hist_details):
    db.add(chatHistDetails)
    db.commit()
    db.refresh(chatHistDetails)


def get_chat_hist_details(db: Session, chatId: str) -> List[models.chat_hist_details]:
    return db.query(models.chat_hist_details).filter(models.chat_hist_details.chat_id == chatId).all()


def delete_chat(db: Session, chatId: str):
    db.query(models.chat_hist_details).filter(models.chat_hist_details.chat_id == chatId).delete()
    db.query(models.chat_hist).filter(models.chat_hist.chat_id == chatId).delete()
    db.commit()
