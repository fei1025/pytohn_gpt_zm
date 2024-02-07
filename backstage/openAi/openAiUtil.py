from typing import List

import tiktoken
from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper

from entity import models
from entity.openAi_entity import TrimMessagesInput

openAI_model = {"0": "gpt-3.5-turbo",
                "1": "gpt-3.5-turbo-16k-0613",
                "2": "gpt-4-0613",
                "3": "gpt-4-32k-0613",
                }

toolList = {}
# 返回的最小数据
re_chat = 1000

token_4 = 4000
token_16 = 8100
token_32 = 32000
model_max_token = {
    "gpt-3.5-turbo": token_4,
    "gpt-3.5-turbo-0613": token_4,
    "gpt-3.5-turbo-16k-0613": token_16,
    "gpt-4-0613": token_4,
    "gpt-4-32k-0613": token_32
}


def get_model_max_token(model: str) -> int:
    return model_max_token[model]


def get_open_model(key: str):
    return openAI_model[key]


def get_all_model():
    models = [{"value": "gpt-3.5-turbo-0613",
               "key": "0"
               },
              {"value": "gpt-3.5-turbo-16k-0613",
               "key": "1",
               },
              {"value": "gpt-4-0613",
               "key": "2"
               },
              {"value": "gpt-4-32k-0613",
               "key": "3"}]
    return models


def num_tokens_from_messages(messages: list, model="gpt-3.5-turbo-0613"):
    """Return the number of tokens used by a list of messages."""
    try:
        encoding = tiktoken.encoding_for_model(model)
    except KeyError:
        print("Warning: model not found. Using cl100k_base encoding.")
        encoding = tiktoken.get_encoding("cl100k_base")
    if model in {
        "gpt-3.5-turbo-0613",
        "gpt-3.5-turbo-16k-0613",
        "gpt-4-0314",
        "gpt-4-32k-0314",
        "gpt-4-0613",
        "gpt-4-32k-0613",
    }:
        tokens_per_message = 3
        tokens_per_name = 1
    elif model == "gpt-3.5-turbo-0301":
        tokens_per_message = 4  # every message follows <|start|>{role/name}\n{content}<|end|>\n
        tokens_per_name = -1  # if there's a name, the role is omitted
    elif "gpt-3.5-turbo" in model:
        print("Warning: gpt-3.5-turbo may update over time. Returning num tokens assuming gpt-3.5-turbo-0613.")
        return num_tokens_from_messages(messages, model="gpt-3.5-turbo-0613")
    elif "gpt-4" in model:
        print("Warning: gpt-4 may update over time. Returning num tokens assuming gpt-4-0613.")
        return num_tokens_from_messages(messages, model="gpt-4-0613")
    else:
        raise NotImplementedError(
            f"""num_tokens_from_messages() is not implemented for model {model}. See https://github.com/openai/openai-python/blob/main/chatml.md for information on how messages are converted to tokens."""
        )
    num_tokens = 0
    for message in messages:
        num_tokens += tokens_per_message
        for key, value in message.items():
            num_tokens += len(encoding.encode(value))
            if key == "name":
                num_tokens += tokens_per_name
    num_tokens += 3  # every reply is primed with <|start|>assistant<|message|>
    return num_tokens


def get_token_count( messages:list, functions:list,model="gpt-3.5-turbo-0613"):
    # Initialize message settings to 0
    msg_init = 0
    msg_name = 0
    msg_end = 0

    # Initialize function settings to 0
    func_init = 0
    prop_init = 0
    prop_key = 0
    enum_init = 0
    enum_item = 0
    func_end = 0

    if model in [
        "gpt-3.5-turbo-0613",
        "gpt-3.5-turbo-16k-0613",
        "gpt-4-0314",
        "gpt-4-32k-0314",
        "gpt-4-0613",
        "gpt-4-32k-0613",
    ]:
        # Set message settings for above models
        msg_init = 3
        msg_name = 1
        msg_end = 3

        # Set function settings for the above models
        func_init = 7
        prop_init = 3
        prop_key = 3
        enum_init = -3
        enum_item = 3
        func_end = 12

    enc = tiktoken.encoding_for_model(model)

    msg_token_count = 0
    for message in messages:
        msg_token_count += msg_init  # Add tokens for each message
        for key, value in message.items():
            msg_token_count += len(enc.encode(value))  # Add tokens in set message
            if key == "name":
                msg_token_count += msg_name  # Add tokens if name is set
    msg_token_count += msg_end  # Add tokens to account for ending

    func_token_count = 0
    if len(functions) > 0:
        for function in functions:
            func_token_count += func_init  # Add tokens for start of each function
            f_name = function["name"]
            f_desc = function["description"]
            if f_desc.endswith("."):
                f_desc = f_desc[:-1]
            line = f_name + ":" + f_desc
            func_token_count += len(enc.encode(line))  # Add tokens for set name and description
            if len(function["parameters"]["properties"]) > 0:
                func_token_count += prop_init  # Add tokens for start of each property
                for key in list(function["parameters"]["properties"].keys()):
                    func_token_count += prop_key  # Add tokens for each set property
                    p_name = key
                    p_type = function["parameters"]["properties"][key]["type"]
                    p_desc = function["parameters"]["properties"][key]["description"]
                    if "enum" in function["parameters"]["properties"][key].keys():
                        func_token_count += enum_init  # Add tokens if property has enum list
                        for item in function["parameters"]["properties"][key]["enum"]:
                            func_token_count += enum_item
                            func_token_count += len(enc.encode(item))
                    if p_desc.endswith("."):
                        p_desc = p_desc[:-1]
                    line = f"{p_name}:{p_type}:{p_desc}"
                    func_token_count += len(enc.encode(line))
        func_token_count += func_end

    return msg_token_count + func_token_count


def trim_messages(data: TrimMessagesInput):
    messages = data.messages
    max_tokens = get_max_tokens(data.model)
    model = data.model
    while num_tokens_from_messages(messages, model) > max_tokens:
        if messages[0].role == "system":
            messages.pop(1)  # 删除第二条消息
        else:
            messages.pop(0)  # 删除第一条消息
    return {"messages": messages, "num": num_tokens_from_messages(messages, model)}


def get_max_tokens(model: str):
    return get_model_max_token(model) - re_chat

def get_tools(setting: models.User_settings):
    WolframAlphaAPIWrapper(wolfram_alpha_appid=setting.wolfram_appid)


def demo():
    tools = [
        {
            "type": "function",
            "function": {
                "name": "get_current_weather",
                "description": "Get the current weather in a given location",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "location": {
                            "type": "string",
                            "description": "The city and state, e.g. San Francisco, CA",
                        },
                        "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]},
                    },
                    "required": ["location"],
                },
            },
        }
    ]
    print(get_token_count(messages=[],functions=tools))
demo()
