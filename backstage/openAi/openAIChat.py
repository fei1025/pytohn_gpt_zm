# import openai
import json

from openai import OpenAI
from openai.types.chat.chat_completion_chunk import ChoiceDeltaToolCall, ChoiceDeltaToolCallFunction

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
    trim_mess = TrimMessagesInput()
    trim_mess.messages = message
    trim_mess.model = openAiUtil.get_open_model(res.model)
    messageNum = openAiUtil.trim_messages(trim_mess)
    print(messageNum)
    max_token = openAiUtil.get_max_tokens(openAiUtil.get_open_model(res.model)) - messageNum['num']
    print(setting.openai_api_base)
    print(setting.openai_api_key)
    # with retrieve_proxy(db):
    client = OpenAI(base_url=setting.openai_api_base, api_key=setting.openai_api_key)
    response = client.chat.completions.create(
        model=openAiUtil.get_open_model(res.model),  # The name of the OpenAI chatbot model to use
        messages=messageNum['messages'],  # The conversation history up to this point, as a list of dictionaries
        max_tokens=max_token,  # The maximum number of tokens (words or subwords) in the generated response
        stop=None,  # The stopping sequence for the generated response, if any (not used here)
        temperature=res.temperature,  # The "creativity" of the generated response (higher temperature = more creative)
        stream=True
    )
    i1 = 0
    content = ""
    modelTools = models.chat_hist_details_tools
    toolList=[]

    for i in response:
        if i1==0:
            i1=i1+1
            continue
        if i.choices[0].delta.tool_calls:
            tool_calls =i.choices[0].delta.tool_calls[0]
            if tool_calls.function.name and tool_calls.function.name != '':
                tool_name=tool_calls.function.name
                modelTools.tools = tool_name
                modelTools.type = "0"
                curFunction= ChoiceDeltaToolCallFunction()
                curFunction.name=tool_calls.function.name
                curFunction.arguments=tool_calls.function.arguments
                toolList.append(curFunction)
                yield json.dumps({'type': "tool", "data": tool_name})
            else:
                curFunction=toolList[tool_calls.index]
                curFunction.arguments=curFunction.arguments+tool_calls.function.arguments

            # arguments=arguments+ tool_calls.function.arguments
        else:
            if i.choices[0].delta.content:
                yield json.dumps({'type': "msg", "data": i.choices[0].delta.content})
                content=content+i.choices[0].delta.content



    return response


def get_history(db: Session, res: reqChat) -> list:
    chat_id = res.chat_id
    chatHistList = crud.get_chat_hist_details(db, chat_id)
    print(f"chatId:{chat_id}获取的历史记录:{chatHistList}")
    message = []
    for chat in chatHistList:
        message.append({"role": chat.role, "content": chat.content})
    return message


def getTools():
    wolfram = MyWolframAlphaAPIWrapper(wolfram_alpha_appid="5V6ELP-UUPQLEAUXU")
    query_run = MyWolframAlphaQueryRun(api_wrapper=wolfram, tags=['a-tag'], )
    available_functions = {
        "wolfram_alpha": query_run.run
    }
    pass
