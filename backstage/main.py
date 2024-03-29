import asyncio
from http.client import HTTPException
from typing import List

import uvicorn
from fastapi import FastAPI, Depends, Request
from langchain.agents import load_tools
from langchain_community.tools.pubmed.tool import PubmedQueryRun

from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper
from langchain_experimental.tools import PythonREPLTool
from pydantic import BaseModel
from sqlalchemy.orm import Session

from db.database import engine, get_db, SessionLocal
from entity import models, schemas, crud
from sse_starlette.sse import EventSourceResponse
from langchain.pydantic_v1 import Field

from web import chatWeb, knowledgeWeb

models.Base.metadata.create_all(bind=engine)

app = FastAPI()
# 计算引擎
# https://python.langchain.com/docs/integrations/providers/wolfram_alpha


app.include_router(chatWeb.router)
app.include_router(knowledgeWeb.router)


@app.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db=db, user=user)


@app.get("/users/", response_model=List[schemas.User])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = crud.get_users(db, skip=skip, limit=limit)
    return users


@app.get("/users/{user_id}", response_model=schemas.User)
def read_user(user_id: int, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user


@app.post("/users/{user_id}/items/", response_model=schemas.Item)
def create_item_for_user(
        user_id: int, item: schemas.ItemCreate, db: Session = Depends(get_db)
):
    return crud.create_user_item(db=db, item=item, user_id=user_id)


@app.get("/items/", response_model=List[schemas.Item])
def read_items(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    items = crud.get_items(db, skip=skip, limit=limit)
    return items


@app.get("/get_user_setting/")
def get_user_setting(db: Session = Depends(get_db)):
    return crud.get_user_setting(db)


@app.get("/getSee")
async def root(request: Request):
    async def event_generator(request: Request):
        res_str = "七夕情人节即将来临，我们为您准备了精美的鲜花和美味的蛋糕"
        for i in res_str:
            if await request.is_disconnected():
                print("连接已中断")
                break
            yield {
                "event": "message",
                "retry": 15000,
                "data": i
            }

            await asyncio.sleep(0.1)

    g = event_generator(request)
    return EventSourceResponse(g)





class GoogleSearchInput(BaseModel):
    keywords: str = Field(description="keywords to search")


class WebBrowsingInput(BaseModel):
    url: str = Field(description="URL of a webpage")


class WebAskingInput(BaseModel):
    url: str = Field(description="URL of a webpage")
    question: str = Field(description="Question that you want to know the answer to, based on the webpage's content.")


# 在应用启动时执行初始化操作
#@app.on_event("startup")
def on_startup():
    global toolList
    # 查询数据库并初始化全局变量
    with SessionLocal() as db:
        setting = crud.get_user_setting(db)
        if setting.wolfram_appid:
            toolList["WolframA"] = WolframAlphaAPIWrapper(wolfram_alpha_appid=setting.wolfram_appid)
        # 当你需要回答有关时事的问题时很有用
        toolList["ddg"] = load_tools(["ddg-search"])
        # 当你需要回答数学问题的时候很有用
        toolList["llm-math"] = load_tools(["llm-math"])
        "A wrapper around Arxiv.org "
        "Useful for when you need to answer questions about Physics, Mathematics, "
        "Computer Science, Quantitative Biology, Quantitative Finance, Statistics, "
        "Electrical Engineering, and Economics "
        "from scientific articles on arxiv.org. "
        "Input should be a search query."
        # 当你需要回答有关物理、数学的问题时很有用，”
        # 计算机科学、数量生物学、数量金融、统计学
        # 电气工程与经济学摘自arxiv.org上的科学文章
        toolList["arxiv"] = load_tools(["arxiv"])
        # 维基百科
        toolList["wikipedia"] = load_tools(["wikipedia"])
        # pyhon执行器
        toolList["PythonREPLTool"] = PythonREPLTool()
        # PubmedQueryRun() 考研 从生物医学文献，MEDLINE，生命科学期刊和在线书籍
        PubmedQueryRun()


if __name__ == '__main__':
    uvicorn.run(app, port=6688, host="0.0.0.0")
