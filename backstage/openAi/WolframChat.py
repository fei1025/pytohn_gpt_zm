import os
from typing import Any

from langchain.callbacks import StreamingStdOutCallbackHandler
from langchain.callbacks.manager import CallbackManager
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
from langchain.schema import SystemMessage, HumanMessage, LLMResult
from langchain.tools import WolframAlphaQueryRun, format_tool_to_openai_function
from langchain.agents import load_tools


os.environ["WOLFRAM_ALPHA_APPID"] = "5V6ELP-UUPQLEAUXU"
openai_api_key = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'

wolfram = WolframAlphaAPIWrapper()

#print(wolfram.run("What is 2x+5 = -3x + 7?"))
# tools = load_tools(["wolfram-alpha"])
query_run = WolframAlphaQueryRun(api_wrapper=wolfram)

tools = [query_run]
functions = [format_tool_to_openai_function(t) for t in tools]

llm = ChatOpenAI(openai_api_key=openai_api_key,verbose=True,openai_api_base="https://api.openai-sb.com/v1",streaming=True,
                 callback_manager=CallbackManager([StreamingStdOutCallbackHandler()]))

message = llm.predict_messages(
    [HumanMessage(content="What is 2x+5 = -3x + 7?")], functions=functions
)
print(message)

text = "What is 2 * 2 * 0.13 - 1.001?"
messages = [HumanMessage(content=text)]

resp = llm(messages)

print(resp)
# #
# text1=""
# result = llm._stream(messages)
# for i in result:
#     print( i.message.content)
#     text1=text1+i.message.content
#
# print(text1)
# print(handler.generate_tokens)
# print(message)






