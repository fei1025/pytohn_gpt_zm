from langchain.agents import load_tools
from langchain_community.tools.arxiv.tool import ArxivQueryRun
from langchain_community.tools.ddg_search import DuckDuckGoSearchRun
from langchain_community.tools.file_management import MoveFileTool
from langchain_community.tools.wolfram_alpha import WolframAlphaQueryRun
from langchain_community.utilities.arxiv import ArxivAPIWrapper
from langchain_community.utilities.duckduckgo_search import DuckDuckGoSearchAPIWrapper
from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper
from langchain_core.utils.function_calling import convert_to_openai_function, convert_to_openai_tool
import json

from langchain_experimental.tools import PythonREPLTool

#wolfram = WolframAlphaAPIWrapper(wolfram_alpha_appid="5V6ELP-UUPQLEAUXU")

#print(wolfram.run("population %20 france"))


# tools = [MoveFileTool()]
# functions = [convert_to_openai_function(t) for t in tools]
#
# print(json.dumps(functions))
#
wolfram=WolframAlphaAPIWrapper(wolfram_alpha_appid="12")
query_run = WolframAlphaQueryRun(api_wrapper=wolfram, tags=['a-tag'])
# ddg-search
DuckDuckGoSearchRun(api_wrapper=DuckDuckGoSearchAPIWrapper())
# #print(json.dumps(convert_to_openai_function(query_run)))
#tools=load_tools(["ddg-search","wikipedia","arxiv"])
# payhotn 代码执行器
PythonREPLTool()
# arxiv
ArxivQueryRun(api_wrapper=ArxivAPIWrapper())
#functions = [convert_to_openai_tool(t) for t in tools]
#print(json.dumps(functions))
tools = [query_run,DuckDuckGoSearchRun(api_wrapper=DuckDuckGoSearchAPIWrapper()),PythonREPLTool(),ArxivQueryRun(api_wrapper=ArxivAPIWrapper())]
functions = [convert_to_openai_tool(t) for t in tools]


#print(functions)
print(json.dumps(functions))

