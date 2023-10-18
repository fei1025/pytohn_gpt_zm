import os

from langchain.memory import ConversationBufferWindowMemory
from langchain.utilities.wolfram_alpha import WolframAlphaAPIWrapper
from langchain.chains import LLMMathChain
from langchain.llms import OpenAI
from langchain.utilities import SerpAPIWrapper
from langchain.utilities import SQLDatabase
from langchain.agents import initialize_agent, Tool
from langchain.agents import AgentType
from langchain.chat_models import ChatOpenAI
from langchain.agents.agent_toolkits import SQLDatabaseToolkit
from langchain.schema import SystemMessage

from langchain.agents import load_tools

os.environ["WOLFRAM_ALPHA_APPID"] = "5V6ELP-UUPQLEAUXU"
openai_api_key = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'

#wolfram = WolframAlphaAPIWrapper()

#print(wolfram.run("What is 2x+5 = -3x + 7?"))
tools = load_tools(["wolfram-alpha"])
llm = ChatOpenAI(openai_api_key=openai_api_key,verbose=True,openai_api_base="https://api.openai-sb.com/v1",streaming=True)

agent = initialize_agent(
    tools,
    llm,
    agent=AgentType.OPENAI_FUNCTIONS,
    verbose=True,
)

agent.run("What is 2 * 2 * 0.13 - 1.001?")
# for message in agent.agent.llm_chain.prompt.messages:
#   print(message)





