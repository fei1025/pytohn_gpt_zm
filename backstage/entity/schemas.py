from typing import Union, Optional

from marshmallow.fields import Bool
from pydantic import BaseModel


class ItemBase(BaseModel):
    title: str
    description: Union[str, None] = None


class ItemCreate(ItemBase):
    pass


class Item(ItemBase):
    id: int
    owner_id: int

    class Config:
        from_attributes = True


class UserBase(BaseModel):
    email: str


class UserCreate(UserBase):
    password: str


class User(UserBase):
    id: int
    is_active: bool
    items: list = []

    class Config:
        from_attributes = True


class userSetting(BaseModel):
    httpProxy: Optional[str] = None
    openaiApiKey: Optional[str] = None
    openaiApiBase: Optional[str] = None
    llm: Optional[str] = None
    theme: Optional[str] = None
    wolframAppid: Optional[str] = None
    model: Optional[str] = None


# 请求聊天记录内容表
class reqChat(BaseModel):
    chat_id: str
    role: str
    content: str
    model: str
    token: int
    temperature: float = 0.7
    stream: bool = True
