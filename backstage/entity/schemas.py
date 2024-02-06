from typing import Union, Optional, List

from marshmallow.fields import Bool, Field
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
    chat_id: Optional[int] = None
    knowledge_id: Optional[int] = None
    role: Optional[str] = None
    type: Optional[str] = None
    content: Optional[str] = None
    model: Optional[str] = None
    token: Optional[int] = None
    title: Optional[str] = None
    temperature: Optional[float] = 0.7
    stream: Optional[bool] = True
    tools: Optional[list] = []
