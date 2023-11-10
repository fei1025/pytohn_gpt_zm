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
        print("没有保存")
        pass
    else:
        print("保存历史记录")
        chatHist = models.chat_hist()
        chatHist.title = res.content
        crud.save_chat_hist(db, chatHist)
        res.chat_id = chatHist.chat_id


    # 保存历史记录
    chatHistDetails = models.chat_hist_details()
    chatHistDetails.chat_id = res.chat_id
    chatHistDetails.content = res.content
    chatHistDetails.role = res.role
    crud.save_chat_hist_details(db, chatHistDetails)

    async def event_generator():
        result = openAichat.send_open_ai(db, res)
        content = ""
        # assistant
        for i in result:
            if await request.is_disconnected():
                print("连接已中断")
                break
            if "stop" != i.choices[0].finish_reason:
                content = content + i.choices[0].delta.content
                yield i.choices[0].delta.content
        chatHistDetails = models.chat_hist_details()
        chatHistDetails.chat_id = res.chat_id
        chatHistDetails.content = content
        chatHistDetails.role = "assistant"
        crud.save_chat_hist_details(db, chatHistDetails)
    g = event_generator()
    return EventSourceResponse(g)
