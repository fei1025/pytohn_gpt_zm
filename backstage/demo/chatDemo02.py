import os
from langchain.agents import load_tools
from langchain_community.callbacks import get_openai_callback
from langchain_community.tools.arxiv.tool import ArxivQueryRun
from langchain_community.tools.ddg_search import DuckDuckGoSearchRun
from langchain_community.tools.file_management import MoveFileTool
from langchain_community.tools.wolfram_alpha import WolframAlphaQueryRun
from langchain_community.utilities.arxiv import ArxivAPIWrapper
from langchain_community.utilities.duckduckgo_search import DuckDuckGoSearchAPIWrapper
from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper
from langchain_core.messages import HumanMessage
from langchain_core.utils.function_calling import convert_to_openai_function
import json
from langchain_community.chat_models import ChatOpenAI
from langchain_experimental.tools import PythonREPLTool

from demo.llmIndexdemo import MyCustomHandlerTwo11

os.environ['OPENAI_API_KEY'] = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'
os.environ['openai_api_base'] = 'https://api.openai-sb.com/v1'
os.environ['LANGCHAIN_TRACING_V2'] = 'true'
os.environ['LANGCHAIN_ENDPOINT'] = 'https://api.smith.langchain.com'
os.environ['LANGCHAIN_API_KEY'] = 'https://api.smith.langchain.com'
os.environ['LANGCHAIN_PROJECT'] = 'https://api.smith.langchain.com'
# https://python.langchain.com/docs/modules/model_io/llms/token_usage_tracking
wolfram = WolframAlphaAPIWrapper(wolfram_alpha_appid="5V6ELP-UUPQLEAUXU")
query_run = WolframAlphaQueryRun(api_wrapper=wolfram, tags=['a-tag'])
model = ChatOpenAI(model="gpt-3.5-turbo",callbacks=[MyCustomHandlerTwo11()],streaming=True)
tools = [query_run,DuckDuckGoSearchRun(api_wrapper=DuckDuckGoSearchAPIWrapper()),PythonREPLTool(),ArxivQueryRun(api_wrapper=ArxivAPIWrapper())]
functions = [convert_to_openai_function(t) for t in tools]
#model_with_tools = model.bind_functions(tools)

#message =model_with_tools.invoke([HumanMessage(content="2 * 2 * 0.13 - 1.001? 如何计算,用中文回复")])

with get_openai_callback() as cb:
    result = model.invoke("2 * 2 * 0.13 - 1.001? 如何计算,用中文回复")
    print(cb)


# message = model.invoke(
#     [HumanMessage(content="2 * 2 * 0.13 - 1.001? 如何计算,用中文回复")], functions=functions
# )
#print(message)

