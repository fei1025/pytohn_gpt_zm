from fastapi import APIRouter

from fastapi import Depends, Request
from sqlalchemy.orm import Session

import openAi.langChat
import openAi.openAIChat as openAichat
from db.database import engine, get_db
from entity import models, schemas, crud

from sse_starlette.sse import EventSourceResponse

from entity.schemas import reqChat

router = APIRouter()


@router.get("/users/")
async def read_users():
    return [{"username": "Rick"}, {"username": "Morty"}]


@router.post("/add_chat")
def add_chat():
    pass



@router.post("/send_open_ai")
def send_open_ai(request: Request, res: reqChat, db: Session = Depends(get_db)):
    async def event_generator(request: Request, res: reqChat):
        res = openAichat.send_open_ai(db, res)
        for i in res:
            if await request.is_disconnected():
                print("连接已中断")
                break
            yield i.message.content
    g = event_generator(request)
    return EventSourceResponse(g)
