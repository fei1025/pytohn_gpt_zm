import json
import traceback
from threading import Thread
from typing import List

from langchain import hub

from langchain.agents import load_tools, create_openai_tools_agent, AgentExecutor

from langchain_community.chat_models.openai import ChatOpenAI

from sqlalchemy.orm import Session

from Util import MyWolfram
from Util.MyWolfram import MyWolframAlphaAPIWrapper, MyWolframAlphaQueryRun
from entity import crud, models
from entity.schemas import reqChat
from openAi import openAiUtil


# https://blog.csdn.net/hy592070616/article/details/132306885 聊天带记忆
def send_open_ai(db: Session, res: reqChat):
    # 获取历史聊天记录
    from openAi import KnowledgeChat
    message: list = KnowledgeChat.get_history(db, res)
    # 设置openAI key
    setting = crud.get_user_setting(db)
    it = openAiUtil.CallbackToIterator()
    myHandler = openAiUtil.MyCustomHandlerTwoNew(it.callback)
    llm1 = ChatOpenAI(model_name=openAiUtil.get_open_model(res.model), temperature=0,
                      openai_api_key=setting.openai_api_key,
                      openai_api_base=setting.openai_api_base)

    tools = get_tools(db, setting, llm1, res, myHandler)
    prompt = hub.pull("hwchase17/openai-tools-agent")

    llm = ChatOpenAI(model_name=openAiUtil.get_open_model(res.model), temperature=0,
                     openai_api_key=setting.openai_api_key,
                     openai_api_base=setting.openai_api_base,
                     streaming=True, callbacks=[myHandler]
                     )


    def thread_func():
        try:
            if len(tools) == 0:
                llm.invoke(message)
            else:
                question = message.pop()
                agent = create_openai_tools_agent(llm, tools, prompt)
                agent_executor = AgentExecutor(agent=agent, tools=tools)
                agent_executor.invoke({"chat_history": message, "input": question})
        except Exception as e:
            print("An error occurred in thread_func:", e)
            traceback.print_exc()
        it.finish()
    t = Thread(target=thread_func)
    t.start()
    saveTolls = []
    partial_text = ""
    modelTools = models.chat_hist_details_tools
    for value in it:
        yield  value
        if "toolStart" == value["type"]:
            modelTools.tools = value["data"]
            modelTools.type = "0"
        elif "toolInput" == value["type"]:
            modelTools.problem = value["data"]
        elif "toolEnd" == value["type"]:
            modelTools.tool_data = value["data"]
            saveTolls.append(modelTools)
        elif "msg" == value["type"]:
            partial_text += value["data"]
    chatHistDetails = models.chat_hist_details()
    chatHistDetails.chat_id = res.chat_id
    chatHistDetails.content = partial_text
    chatHistDetails.role = "assistant"
    crud.save_chat_hist_details(db, chatHistDetails)
    for tool in saveTolls:
        tool.chat_details_id = chatHistDetails.id
        crud.save_chat_hist_details_tool(db, tool)


def get_tools(db: Session, setting: models.User_settings, llm, res: reqChat, myHandler) -> []:
    toolList = []
    chatHist = crud.get_Hist_by_id(db, res.chat_id)
    tools = chatHist.tools
    if tools is not None and tools != '':
        toolss = openAiUtil.getAllTool()
        for tool in tools.split(","):
            if tool == "llm-math":
                toolList.append(load_tools(["llm-math"], llm=llm, callbacks=myHandler))
            elif tool == "open-meteo-api":
                toolList.append(load_tools(["open-meteo-api"], llm=llm, callbacks=myHandler))
            elif tool == "wolfram_alpha":
                wolfram = MyWolframAlphaAPIWrapper(wolfram_alpha_appid=setting.wolfram_appid, llm=llm)
                # WolframAlpha
                query_run = MyWolframAlphaQueryRun(api_wrapper=wolfram, callbacks=[myHandler])
                query_run.name="WolframAlpha"
                toolList.append(query_run)
            else:
                toolList.append(toolss[tool](callbacks=myHandler))
    return toolList
