import os
from abc import ABC
from typing import Any, Dict, List, Optional, Union
from uuid import UUID

from langchain.memory import ConversationBufferMemory
from langchain_community.tools.pubmed.tool import PubmedQueryRun
from langchain.agents import initialize_agent, AgentType, load_tools
from langchain.callbacks import StdOutCallbackHandler
from langchain.callbacks.base import BaseCallbackHandler

# from langchain_community.chat_models import ChatOpenAI
from langchain_community.chat_models.openai import ChatOpenAI
from langchain.schema import LLMResult, AgentAction, AgentFinish
from langchain_community.tools import WolframAlphaQueryRun, format_tool_to_openai_function
from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper


from langchain.utils import print_text
from langchain_core.messages import HumanMessage, AIMessage
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_experimental.tools import PythonREPLTool

from sqlalchemy.orm import Session

from entity import crud, models
from entity.openAi_entity import TrimMessagesInput
from entity.schemas import reqChat
from openAi import openAiUtil


# https://blog.csdn.net/hy592070616/article/details/132306885 聊天带记忆
def send_open_ai(db: Session, res: reqChat):
    prompt = ChatPromptTemplate.from_messages(
        [
            (
                "system",
                "You are a helpful assistant. You may not need to use tools for every query - the user may just want to chat!",
            ),
            MessagesPlaceholder(variable_name="messages"),
            MessagesPlaceholder(variable_name="agent_scratchpad"),
        ]
    )
    prompt.save()
    # 获取历史聊天记录
    from openAi import KnowledgeChat
    message: list = KnowledgeChat.get_history(db, res)
    # 设置openAI key
    setting = crud.get_user_setting(db)
    llm = ChatOpenAI(model_name=openAiUtil.get_open_model(res.model),
                     temperature=0,
                     streaming=True)
    tools = get_tools(res.tools, setting, llm)
    agent = initialize_agent(llm, agent=AgentType.STRUCTURED_CHAT_ZERO_SHOT_REACT_DESCRIPTION)
    agent.tools=tools
    question = message.pop()
    content: str = ""
    for chunk in agent.stream({"question": question.content, "chat_history": message}):
        if chunk.content is not None:
            yield chunk.content
            content = content + chunk.content



def get_tools(tools: [], setting: models.User_settings, llm) -> []:
    toolList = []
    # if setting.wolfram_appid:
    #     toolList["Wolfram"] = WolframAlphaAPIWrapper(wolfram_alpha_appid=setting.wolfram_appid)
    #     # 当你需要回答有关时事的问题时很有用
    # toolList["ddg"] = load_tools(["ddg-search"])
    # # 当你需要回答数学问题的时候很有用
    # toolList["llm-math"] = load_tools(["llm-math"])
    # "A wrapper around Arxiv.org "
    # "Useful for when you need to answer questions about Physics, Mathematics, "
    # "Computer Science, Quantitative Biology, Quantitative Finance, Statistics, "
    # "Electrical Engineering, and Economics "
    # "from scientific articles on arxiv.org. "
    # "Input should be a search query."
    # # 当你需要回答有关物理、数学的问题时很有用，”
    # # 计算机科学、数量生物学、数量金融、统计学
    # # 电气工程与经济学摘自arxiv.org上的科学文章
    # toolList["arxiv"] = load_tools(["arxiv"])
    # # 维基百科
    # toolList["wikipedia"] = load_tools(["wikipedia"])
    # # pyhon执行器
    # toolList["PythonREPLTool"] = PythonREPLTool()
    # # PubmedQueryRun() 考研 从生物医学文献，MEDLINE，生命科学期刊和在线书籍
    # PubmedQueryRun()
    if len(toolList) != 0:
        toolList = load_tools(tools, llm=llm)
        for s in tools:
            if "Wolfram" == s:
                toolList.append(WolframAlphaAPIWrapper(wolfram_alpha_appid=setting.wolfram_appid))
    return toolList
