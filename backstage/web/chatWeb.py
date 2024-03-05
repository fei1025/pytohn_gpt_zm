import json
import os

from fastapi import APIRouter, Query, UploadFile, File, Form

from fastapi import Depends, Request
from sqlalchemy.orm import Session

import openAi.openAIChat as openAichat
import openAi.openAiUtil as openAiUtil
import openAi.KnowledgeChat as knowledgeChat
import openAi.langOpenAiChat as langOpenAiChat
from Util.result import Result
from db.database import engine, get_db
from entity import models, schemas, crud

from sse_starlette.sse import EventSourceResponse

from entity.schemas import reqChat, userSetting

router = APIRouter()


@router.get("/users")
async def read_users():
    return [{"username": "Rick"}, {"username": "Morty"}]


@router.get("/getUserSetting")
async def get_user_setting(db: Session = Depends(get_db)):
    return Result.success(data=crud.get_user_setting(db))


@router.get("/get_all_model")
async def get_all_model():
    return Result.success(data=openAiUtil.get_all_model())

@router.get("/get_all_tools")
async def get_all_tools():
    return Result.success(data=openAiUtil.getAllToolNew())


@router.post("/saveUserSetting")
async def save_user_setting(setting: userSetting, db: Session = Depends(get_db)):
    userSetting = models.User_settings()
    userSetting.model = setting.model
    userSetting.http_proxy = setting.httpProxy
    userSetting.wolfram_appid = setting.wolframAppid
    userSetting.openai_api_base = setting.openaiApiBase
    userSetting.openai_api_key = setting.openaiApiKey
    userSetting.theme = setting.theme
    crud.save_user_setting(db, userSetting)
    return Result.success()


@router.get("/delete_chat")
async def delete_chat(chatId: str, db: Session = Depends(get_db)):
    crud.delete_chat(db, chatId)
    return Result.success()


@router.get("/delete_all_chat")
async def delete_all_chat(db: Session = Depends(get_db)):
    crud.delete_all_chat(db)
    return Result.success()


@router.get("/getAllHist")
async def get_all_Hist(type: str, db: Session = Depends(get_db)):
    list = crud.get_all_Hist(db, type)
    return Result.success(list)


@router.get("/getChatHistDetails")
async def get_chat_hist_details(db: Session = Depends(get_db), chatId: int = Query(...)):
    chat_hist_details = crud.get_chat_hist_details(db, chatId)
    for item in chat_hist_details:
        item.toolList=crud.get_chat_hist_details_tool(db,item.id)
        if item.other_data:
            item.other_data_list=json.loads(item.other_data)
            item.other_data=None
    return Result.success(chat_hist_details)


@router.post("/save_chat_hist")
async def save_chat_hist(res: reqChat, db: Session = Depends(get_db)):
    chatHist = models.chat_hist()
    chatHist.title = res.content
    chatHist.type = res.type
    chatHist.knowledge_id = res.knowledge_id
    crud.save_chat_hist(db, chatHist)
    return Result.success([chatHist])



@router.post("/update_chat")
async def update_chat(res: reqChat, db: Session = Depends(get_db)):
    chatHist = models.chat_hist()
    chatHist.chat_id = res.chat_id
    chatHist.model = res.model
    chatHist.title = res.title
    chatHist.tools=res.tools
    crud.update_chat(db, chatHist)
    return Result.success()


# @router.post("/send_open_ai")
# @router.post("/update_chat")
async def send_open_ai1(request: Request):
    # 获取请求中的所有数据
    all_data = await  request.json()
    print(f"接受到的所有数据:{all_data}")


@router.post("/send_open_ai")
def send_open_ai(request: Request, res: reqChat, db: Session = Depends(get_db)):
    # 保存历史记录
    print(res.chat_id)
    chatHistDetails = models.chat_hist_details()
    chatHistDetails.chat_id = res.chat_id
    chatHistDetails.content = res.content
    chatHistDetails.role = res.role
    crud.save_chat_hist_details(db, chatHistDetails)
    chatHist = crud.get_Hist_by_id(db,res.chat_id)
    res.knowledge_id=chatHist.knowledge_id
    if chatHist.type == "0":
        async def event_generator():
            #正常聊天
            result = openAichat.send_open_ai(db, res)
            content = ""
            for i in result:
                if await request.is_disconnected():
                    print("连接已中断")
                    break
                if "stop" != i.choices[0].finish_reason:
                    print(i.choices[0])
                    content = content + i.choices[0].delta.content
                    #yield i.choices[0].delta.content
                    yield json.dumps({'type': "msg", "data": i.choices[0].delta.content})
            chatHistDetails = models.chat_hist_details()
            chatHistDetails.chat_id = res.chat_id
            chatHistDetails.content = content
            chatHistDetails.role = "assistant"
            crud.save_chat_hist_details(db, chatHistDetails)
        g = event_generator()
        return EventSourceResponse(g)
    elif chatHist.type == "1":
        # 知识库聊天
        async def event_generator():
            data_generator = knowledgeChat.send_open_ai(db, res)
            if await request.is_disconnected():
                print("连接已中断")
            for data_point in data_generator:
                yield json.dumps({'type': "msg", "data": data_point})

        g = event_generator()
        return EventSourceResponse(g)
    elif  chatHist.type == "2":
        # 有插件的聊天
        async def event_generator():
            data_generator = langOpenAiChat.send_open_ai(db, res)
            if await request.is_disconnected():
                print("连接已中断")
            for data_point in data_generator:
                yield json.dumps(data_point)
        g = event_generator()
        return EventSourceResponse(g)
