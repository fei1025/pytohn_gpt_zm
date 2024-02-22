import os
from dataclasses import Field
from typing import Optional

from langchain.chains import APIChain
from langchain_community.tools.tavily_search import TavilySearchResults
from langchain_community.tools.wolfram_alpha import WolframAlphaQueryRun
from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper
from langchain_core.callbacks import CallbackManagerForToolRun
from langchain_core.messages import HumanMessage, AIMessage
from langchain_core.tools import Tool, BaseTool
from langchain_experimental.tools import PythonREPLTool
from pydantic import BaseModel

from Util import MyWolfram, myTools
from Util.MyWolfram import MyWolframAlphaAPIWrapper, MyWolframAlphaQueryRun
from demo.llmIndexdemo import MyCustomHandlerTwo11

os.environ['OPENAI_API_KEY'] = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'
os.environ['openai_api_base'] = 'https://api.openai-sb.com/v1'
os.environ['TAVILY_API_KEY'] = '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'
os.environ['LANGCHAIN_TRACING_V2'] = 'true'
os.environ['LANGCHAIN_ENDPOINT'] = 'https://api.smith.langchain.com'
os.environ['LANGCHAIN_API_KEY'] = 'ls__efe3168def034c7a9161e91bfacaf333'
os.environ['LANGCHAIN_PROJECT'] = 'pt-formal-mountain-58'

# os.environ["WOLFRAM_ALPHA_APPID"] = "5V6ELP-UUPQLEAUXU"
openai_api_key = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'
# https://products.wolframalpha.com/llm-api/documentation
wolfram = WolframAlphaAPIWrapper(wolfram_alpha_appid="5V6ELP-UUPQLEAUXU")
from langchain_community.chat_models.openai import ChatOpenAI
from langchain import hub
from langchain.agents import create_openai_functions_agent, create_openai_tools_agent
from langchain.agents import AgentExecutor



#query_run = WolframAlphaQueryRun(api_wrapper=wolfram, tags=['a-tag'],callbacks=[MyCustomHandlerTwo11()])
llm1 = ChatOpenAI(model="gpt-3.5-turbo-1106", temperature=0,callbacks=[MyCustomHandlerTwo11()])
from pydantic.v1 import BaseModel, Field

wolfram = MyWolframAlphaAPIWrapper(wolfram_alpha_appid="5V6ELP-UUPQLEAUXU",llm=llm1)
query_run = MyWolframAlphaQueryRun(api_wrapper=wolfram, tags=['a-tag'],callbacks=[MyCustomHandlerTwo11()])


# chain = APIChain.from_llm_and_api_docs(
#     llm1,
#     myTools.wolfrmpo,
#     headers={"Authorization":"Bearer 5V6ELP-UUPQLEAUXU"},
#     limit_to_domains=None,
# )
# query_run=Tool(
#         name="wrapper",
#         description=(
#         "A wrapper around Wolfram Alpha. "
#         "Useful for when you need to answer questions about Math, "
#         "Science, Technology, Culture, Society and Everyday Life. "
#         "Input should be a search query."
#     ),
#         func=chain.run,
#         callbacks=[MyCustomHandlerTwo11()]
#     )



# retriever_tool = create_retriever_tool(
#     retriever,
#     "langsmith_search",
#     "Search for information about LangSmith. For any questions about LangSmith, you must use this tool!",
# )
search = TavilySearchResults(max_results=1,callbacks=[MyCustomHandlerTwo11()])
pythonSheel=PythonREPLTool(callbacks=[MyCustomHandlerTwo11()])


#tools = [search,query_run,pythonSheel]
tools = [query_run]


# # Get the prompt to use - you can modify this!
# prompt = hub.pull("hwchase17/openai-functions-agent")
# llm = ChatOpenAI(model="gpt-3.5-turbo", temperature=0,streaming=True)
# agent = create_openai_functions_agent(llm, tools, prompt)
#
# #agent_executor = AgentExecutor()
# agent_executor=AgentExecutor.from_agent_and_tools(agent=agent, tools=tools,callbacks=[MyCustomHandlerTwo11()])
chat_history = [HumanMessage(content="Can LangSmith help test my LLM applications?"), AIMessage(content="Yes!")]
## agent = agent_executor.invoke({"chat_history": chat_history,"input": "Tell me how"})
# agent = agent_executor.invoke({"input": "体重为 72 公斤，以 4 英里每小时的速度，走路 45 分钟后的心率、卡路里消,用中文回复"})
# print(agent)
# #print(agent_executor.invoke({"chat_history": chat_history,"input": "Tell me how"}))

#-----------------------------------------------
prompt = hub.pull("hwchase17/openai-tools-agent")

# Choose the LLM that will drive the agent
# Only certain models support this
llm = ChatOpenAI(model="gpt-3.5-turbo-1106", temperature=0,streaming=True,callbacks=[MyCustomHandlerTwo11()])

# Construct the OpenAI Tools agent
agent = create_openai_tools_agent(llm, tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools,    callbacks=[MyCustomHandlerTwo11()])
#chat_history = [HumanMessage(content="文件路径 C:\\Users\\86158\\Desktop\\用户信息 (2).xls")]
#print(agent_executor.invoke({"chat_history": chat_history,"input": "用python代码解析下上面文件,统计下每个 负责部门 有多少数据,同时给我生成一张饼状图片出来,生成图片的时候,你要考虑到中文乱码的问题,你还要考虑到如果数据太密集生成的图片里面负责部门名字会重叠的问题,同时你要把图片路径打印出来,并且用把 图片用markdown格式返回"}))
# print(agent_executor.invoke({"chat_history": chat_history,"input": "用python代码解析下上面文件,统计下每个 负责部门 有多少数据,同时给我生成一张饼状图片出来"}))

#agent = agent_executor.invoke({"chat_history": chat_history,"input": "Tell me how"})
#agent = agent_executor.invoke({"input": "体重为 72 公斤，以 4 英里每小时的速度，走路 45 分钟后的心率、卡路里消耗,我,用中文回复"})
agent = agent_executor.invoke({"input": "10+densest+elemental+metals,用中文回复"})
print(agent["output"])

