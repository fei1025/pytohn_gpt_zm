from threading import Thread

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
    llm = ChatOpenAI(model_name=openAiUtil.get_open_model(res.model),
                     temperature=0,
                     streaming=True)
    tools = get_tools(setting, llm, res, myHandler)
    prompt = hub.pull("hwchase17/openai-tools-agent")
    llm = ChatOpenAI(model="gpt-3.5-turbo-1106", temperature=0, streaming=True, callbacks=[myHandler])
    question = message.pop()

    def thread_func():
        agent = create_openai_tools_agent(llm, tools, prompt)
        agent_executor = AgentExecutor(agent=agent, tools=tools, callbacks=[myHandler])
        agent_executor.invoke({"chat_history": message, "input": question})
        message.append(question)

    t = Thread(target=thread_func)
    t.start()
    partial_text = ""
    for value in it:
        partial_text += value
        yield partial_text


def get_tools(setting: models.User_settings, llm, res: reqChat, myHandler) -> []:
    toolList = []
    chatHist = crud.get_Hist_by_id(res.chat_id)
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
                query_run = MyWolframAlphaQueryRun(api_wrapper=wolfram, callbacks=[myHandler])
                toolList.append(query_run)
            else:
                toolList.append(toolss[tool](callbacks=myHandler))
    return toolList
