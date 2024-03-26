# import openai
import json

from langchain_community.tools.arxiv.tool import ArxivQueryRun
from langchain_community.tools.ddg_search import DuckDuckGoSearchRun
from langchain_community.utilities.arxiv import ArxivAPIWrapper
from langchain_community.utilities.duckduckgo_search import DuckDuckGoSearchAPIWrapper
from langchain_core.utils.function_calling import convert_to_openai_tool
from langchain_experimental.tools import PythonREPLTool
from openai import OpenAI
from tool import sys_role
from tool import dalle as dalle_3

from sqlalchemy.orm import Session

from Util.MyWolfram import MyWolframAlphaAPIWrapper, MyWolframAlphaQueryRun
from entity import crud, models
from entity.openAi_entity import TrimMessagesInput
from entity.schemas import reqChat
from openAi import openAiUtil

from openAi.config import retrieve_proxy


def send_open_ai(db: Session, res: reqChat):
    # 获取历史聊天记录
    message: list = get_history(db, res)
    # 设置openAI key
    setting = crud.get_user_setting(db)
    print(f"设置参数:{setting.openai_api_base}")
    print(f"设置参数:{setting.openai_api_key}")
    chatHist = crud.get_Hist_by_id(db, res.chat_id)
    tools = chatHist.tools
    if tools is not None:
        if "wolfram_alpha" in tools:
            mess = message[0]
            if "system" == mess['role']:
                mess['content'] = mess['content'] + " " + sys_role.wolfram_prompt
                message[0] = mess
            else:
                message.insert(0, {"role": "system", "content": sys_role.wolfram_prompt})
        elif "lobe_image_designer" in tools:
            mess = message[0]
            if "system" == mess['role']:
                mess['content'] = mess['content'] + " " + sys_role.dall_e_3
                message[0] = mess
            else:
                message.insert(0, {"role": "system", "content": sys_role.dall_e_3})

    trim_mess = TrimMessagesInput()
    trim_mess.messages = message
    trim_mess.model = openAiUtil.get_open_model(res.model)
    messageNum = openAiUtil.trim_messages(trim_mess)
    print(messageNum)
    max_token = openAiUtil.get_max_tokens(openAiUtil.get_open_model(res.model)) - messageNum['num']
    print(setting.openai_api_base)
    print(setting.openai_api_key)
    print(openAiUtil.get_open_model(res.model))
    # with retrieve_proxy(db):
    selectTools = getSelectTools(db, res)
    tool_choice = None
    if selectTools:
        tool_choice = "auto"
    print(f"选择的方法:{selectTools}")
    print(f"tool_choice:{tool_choice}")

    client = OpenAI(base_url=setting.openai_api_base, api_key=setting.openai_api_key)

    response = client.chat.completions.create(
        model=openAiUtil.get_open_model(res.model),  # The name of the OpenAI chatbot model to use
        # model='gpt3516',  # The name of the OpenAI chatbot model to use
        messages=messageNum['messages'],  # The conversation history up to this point, as a list of dictionaries
        max_tokens=max_token,  # The maximum number of tokens (words or subwords) in the generated response
        stop=None,  # The stopping sequence for the generated response, if any (not used here)
        temperature=res.temperature,  # The "creativity" of the generated response (higher temperature = more creative)
        stream=True,
        tools=selectTools,
        tool_choice=tool_choice
    )
    i1 = 0
    content = ""
    toolList = []
    for i in response:
        print(i)
        if i1 == 0 and (len(i.choices) == 0 or (i.choices[0].delta.content is None and i.choices[0].delta.tool_calls is None)):
            i1 = i1 + 1
            continue
        if i.choices[0].delta.tool_calls:
            tool_calls = i.choices[0].delta.tool_calls[0]
            if tool_calls.function.name and tool_calls.function.name != '':
                tool_name = tool_calls.function.name
                # function1 =ChoiceDeltaToolCallFunction()
                # curFunction = ChatCompletionMessageToolCall(id=tool_calls.id,function=tool_calls.function)
                # curFunction.function.name = tool_calls.function.name
                # curFunction.function.arguments = tool_calls.function.arguments
                toolList.append(tool_calls)
                yield json.dumps({'type': "toolStart", "data": tool_name})
            else:
                curFunction = toolList[tool_calls.index]
                curFunction.function.arguments = curFunction.function.arguments + tool_calls.function.arguments
                toolList[tool_calls.index] = curFunction
        else:
            if i.choices[0].delta.content:
                yield json.dumps({'type': "msg", "data": i.choices[0].delta.content})
                content = content + i.choices[0].delta.content
    if len(toolList) == 0:
        chatHistDetails = models.chat_hist_details()
        chatHistDetails.chat_id = res.chat_id
        chatHistDetails.content = content
        chatHistDetails.role = "assistant"
        crud.save_chat_hist_details(db, chatHistDetails)

    if len(toolList) != 0:
        assistant_message = {"role": "assistant", "tool_calls": toolList, "content": None}
        available_functions = getTools(setting)
        messageNum['messages'].append(assistant_message)
        saveTolls = []
        for tool_call in toolList:
            function_name = tool_call.function.name
            function_to_call = available_functions[function_name]
            function_args = json.loads(tool_call.function.arguments)
            print(f"function_args:{function_args}")
            yield json.dumps({'type': "toolInput", "data": tool_call.function.arguments})
            toolsListName = ["wolfram_alpha", "Python_REPL", "arxiv", "duckduckgo_search"]
            if function_name in toolsListName:
                function_response = function_to_call(
                    function_args.get("__arg1")
                )
            else:
                function_response = function_to_call(**function_args)

            yield json.dumps({'type': "toolEnd", "data": function_response})
            modelTools = models.chat_hist_details_tools()
            modelTools.tools = function_name
            modelTools.type = "0"
            modelTools.tool_data = function_response
            modelTools.problem = function_args.get("__arg1")
            saveTolls.append(modelTools)
            messageNum['messages'].append(
                {
                    "tool_call_id": tool_call.id,
                    "role": "tool",
                    "name": function_name,
                    "content": function_response,
                }
            )  # extend conversation with function response
        second_response = client.chat.completions.create(
            model=openAiUtil.get_open_model(res.model),
            messages=messageNum['messages'],
            max_tokens=max_token,  # The maximum number of tokens (words or subwords) in the generated response
            stop=None,  # The stopping sequence for the generated response, if any (not used here)
            temperature=res.temperature,
            # The "creativity" of the generated response (higher temperature = more creative)
            stream=True
        )
        for i in second_response:
            if len(i.choices) == 0:
                continue
            if i.choices[0].delta.content:
                yield json.dumps({'type': "msg", "data": i.choices[0].delta.content})
                content = content + i.choices[0].delta.content
        chatHistDetails = models.chat_hist_details()
        chatHistDetails.chat_id = res.chat_id
        chatHistDetails.content = content
        chatHistDetails.role = "assistant"
        crud.save_chat_hist_details(db, chatHistDetails)
        for tool in saveTolls:
            tool.chat_details_id = chatHistDetails.id
            crud.save_chat_hist_details_tool(db, tool)


def get_history(db: Session, res: reqChat) -> list:
    chat_id = res.chat_id
    chatHistList = crud.get_chat_hist_details(db, chat_id)
    print(f"chatId:{chat_id}获取的历史记录:{chatHistList}")
    message = []
    for chat in chatHistList:
        message.append({"role": chat.role, "content": chat.content})
    return message


def getSelectTools(db: Session, res: reqChat) -> []:
    toolList = []
    chatHist = crud.get_Hist_by_id(db, res.chat_id)
    tools = chatHist.tools
    if tools is not None and tools != '':
        for tool in tools.split(","):
            if "wolfram_alpha" == tool:
                wolfram = MyWolframAlphaAPIWrapper(wolfram_alpha_appid="54")
                query_run = MyWolframAlphaQueryRun(api_wrapper=wolfram)
                toolList.append(query_run)
            elif "Python_REPL" == tool:
                toolList.append(PythonREPLTool())
            elif "arxiv" == tool:
                toolList.append(ArxivQueryRun(api_wrapper=ArxivAPIWrapper()))
            elif "ddg" == tool:
                toolList.append(DuckDuckGoSearchRun(api_wrapper=DuckDuckGoSearchAPIWrapper()))
            elif "lobe_image_designer" == tool:
                toolList.append(dalle_3.dalle_3fu)
    if len(toolList) == 0:
        return None
    return [convert_to_openai_tool(t) for t in toolList]


def getTools(setting: models.User_settings) -> {}:
    wolfram = MyWolframAlphaAPIWrapper(wolfram_alpha_appid=setting.wolfram_appid)
    query_run = MyWolframAlphaQueryRun(api_wrapper=wolfram)
    available_functions = {
        "wolfram_alpha": query_run.run,
        "Python_REPL": PythonREPLTool().run,
        "arxiv": ArxivQueryRun(api_wrapper=ArxivAPIWrapper()).run,
        "duckduckgo_search": DuckDuckGoSearchRun(api_wrapper=DuckDuckGoSearchAPIWrapper()).run,
        "lobe_image_designer": dalle_3.dalle_3().lobe_image_designer
    }
    return available_functions
