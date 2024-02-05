import os
from abc import ABC
from typing import Any, Dict, List, Optional, Union
from uuid import UUID

from langchain.memory import ConversationBufferMemory
from langchain_community.utilities import WolframAlphaAPIWrapper
from langchain.agents import initialize_agent, AgentType
from langchain.callbacks import StdOutCallbackHandler
from langchain.callbacks.base import BaseCallbackHandler

# from langchain_community.chat_models import ChatOpenAI
from langchain_community.chat_models.openai import ChatOpenAI
from langchain.schema import LLMResult, AgentAction, AgentFinish
from langchain_community.tools import WolframAlphaQueryRun, format_tool_to_openai_function
from langchain.utils import print_text
from langchain_core.messages import HumanMessage, AIMessage
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_experimental.tools import PythonREPLTool

from sqlalchemy.orm import Session

from entity import crud
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
    # 获取历史聊天记录
    from openAi import KnowledgeChat
    message: list = KnowledgeChat.get_history(db, res)
    # 设置openAI key
    setting = crud.get_user_setting(db)
    llm = ChatOpenAI(model_name=openAiUtil.get_open_model(res.model),
                     temperature=0,
                     streaming=True)
    memory = ConversationBufferMemory()
    memory.chat_memory.add_user_message()


def get_tools():
    pass


