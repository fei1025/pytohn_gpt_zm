import os


from langchain_community.tools.tavily_search import TavilySearchResults
from langchain_community.tools.wolfram_alpha import WolframAlphaQueryRun
from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper
from langchain_core.messages import HumanMessage, AIMessage

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

wolfram = WolframAlphaAPIWrapper(wolfram_alpha_appid="5V6ELP-UUPQLEAUXU")
from langchain_community.chat_models.openai import ChatOpenAI
from langchain import hub
from langchain.agents import create_openai_functions_agent, create_openai_tools_agent
from langchain.agents import AgentExecutor
query_run = WolframAlphaQueryRun(api_wrapper=wolfram, tags=['a-tag'])

# retriever_tool = create_retriever_tool(
#     retriever,
#     "langsmith_search",
#     "Search for information about LangSmith. For any questions about LangSmith, you must use this tool!",
# )
search = TavilySearchResults(max_results=1)


tools = [search,query_run]


# # Get the prompt to use - you can modify this!
# prompt = hub.pull("hwchase17/openai-functions-agent")
# llm = ChatOpenAI(model="gpt-3.5-turbo", temperature=0,streaming=True)
# agent = create_openai_functions_agent(llm, tools, prompt)
#
# #agent_executor = AgentExecutor()
# agent_executor=AgentExecutor.from_agent_and_tools(agent=agent, tools=tools,callbacks=[MyCustomHandlerTwo11()])
# # chat_history = [HumanMessage(content="Can LangSmith help test my LLM applications?"), AIMessage(content="Yes!")]
# # agent = agent_executor.invoke({"chat_history": chat_history,"input": "Tell me how"})
# agent = agent_executor.invoke({"input": "体重为 72 公斤，以 4 英里每小时的速度，走路 45 分钟后的心率、卡路里消,用中文回复"})
# print(agent)
# #print(agent_executor.invoke({"chat_history": chat_history,"input": "Tell me how"}))

#-----------------------------------------------
prompt = hub.pull("hwchase17/openai-tools-agent")

# Choose the LLM that will drive the agent
# Only certain models support this
llm = ChatOpenAI(model="gpt-3.5-turbo-1106", temperature=0,callbacks=[MyCustomHandlerTwo11()])

# Construct the OpenAI Tools agent
agent = create_openai_tools_agent(llm, tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools,callbacks=[MyCustomHandlerTwo11()])
agent_executor.invoke({"input": "体重为 72 公斤，以 4 英里每小时的速度，走路 45 分钟后的心率、卡路里消,用中文回复"})


