import os
# from langchain_community.tools.wolfram_alpha import WolframAlphaQueryRun
# from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper
# from langchain_core.utils.function_calling import convert_to_openai_function, convert_to_openai_tool
# from langchain_community.chat_models import ChatOpenAI
# from langchain_experimental.tools import PythonREPLTool
#
# from demo.llmIndexdemo import MyCustomHandlerTwo11
# import json
# os.environ['OPENAI_API_KEY'] = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'
# os.environ['openai_api_base'] = 'https://api.openai-sb.com/v1'
# os.environ['LANGCHAIN_TRACING_V2'] = 'true'
# os.environ['LANGCHAIN_ENDPOINT'] = 'https://api.smith.langchain.com'
# os.environ['LANGCHAIN_API_KEY'] = 'ls__efe3168def034c7a9161e91bfacaf333'
# os.environ['LANGCHAIN_PROJECT'] = 'pt-formal-mountain-58'
# # https://python.langchain.com/docs/modules/model_io/llms/token_usage_tracking
# wolfram = WolframAlphaAPIWrapper(wolfram_alpha_appid="5V6ELP-UUPQLEAUXU")
# query_run = WolframAlphaQueryRun(api_wrapper=wolfram, tags=['a-tag'])
# model = ChatOpenAI(model="gpt-3.5-turbo",callbacks=[MyCustomHandlerTwo11()],streaming=True)
# tools = [query_run,PythonREPLTool()]
# functions = [convert_to_openai_tool(t) for t in tools]
#
# print(json.dumps(functions))
#model_with_tools = model.bind_functions(tools)

#message =model_with_tools.invoke([HumanMessage(content="2 * 2 * 0.13 - 1.001? 如何计算,用中文回复")])

# with get_openai_callback() as cb:
#     result = model.invoke("体重为 72 公斤，以 4 英里每小时的速度，走路 45 分钟后的心率、卡路里消,用中文回复")
#     print(cb)


# message = model.invoke(
#     [HumanMessage(content="2 * 2 * 0.13 - 1.001? 如何计算,用中文回复")], functions=functions
# )
#print(message)

current_directory = os.getcwd()
print(current_directory)

