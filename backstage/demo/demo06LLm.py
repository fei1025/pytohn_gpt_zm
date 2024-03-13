from langchain import hub
from langchain.agents import create_openai_tools_agent, AgentExecutor
from langchain.tools import retriever
from langchain.tools.retriever import create_retriever_tool
from langchain_community.chat_models import ChatOpenAI
from langchain_experimental.tools import PythonREPLTool

llm = ChatOpenAI(temperature=0)

tools = [PythonREPLTool()]
prompt = hub.pull("hwchase17/openai-tools-agent")

agent = create_openai_tools_agent(llm, tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools)
for ch in agent_executor.stream({"input": "hi, im bob"}):
    print(ch)