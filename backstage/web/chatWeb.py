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


# @router.post("/add_chat")
# def add_chat(chatHist: models.chat_hist, db: Session = Depends(get_db)):
#     pass


@router.post("/send_open_ai")
def send_open_ai(request: Request, res: reqChat, db: Session = Depends(get_db)):
    if res.chat_id:
        pass
    else:
        chatHist = models.chat_hist()
        chatHist.title = res.content
        crud.save_chat_hist(db, chatHist)
        res.chat_id = chatHist.chat_id

    async def event_generator(request: Request, input_res: reqChat):
        result = openAichat.send_open_ai(db, input_res)
        for i in result:
            if await request.is_disconnected():
                print("连接已中断")
                break
            yield i.message.content

    g = event_generator(request,res)
    return EventSourceResponse(g)
