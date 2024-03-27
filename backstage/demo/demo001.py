from langchain_community.tools.arxiv.tool import ArxivQueryRun
from langchain_community.tools.ddg_search import DuckDuckGoSearchRun
from langchain_community.utilities.arxiv import ArxivAPIWrapper
from langchain_community.utilities.duckduckgo_search import DuckDuckGoSearchAPIWrapper
from langchain_core.utils.function_calling import convert_to_openai_tool

from Util.MyWolfram import MyWolframAlphaAPIWrapper, MyWolframAlphaQueryRun

# query
# aa = DuckDuckGoSearchRun(api_wrapper=DuckDuckGoSearchAPIWrapper())
# query
 #aa = ArxivQueryRun(api_wrapper=ArxivAPIWrapper())
#__arg1
wolfram = MyWolframAlphaAPIWrapper(wolfram_alpha_appid="54")
aa=MyWolframAlphaQueryRun(api_wrapper=wolfram)
print(convert_to_openai_tool(aa))

