from typing import List

import tiktoken

from entity.openAi_entity import TrimMessagesInput

openAI_model = {"0": "gpt-3.5-turbo",
                "1": "gpt-3.5-turbo-16k-0613",
                "2": "gpt-4-0613",
                "3": "gpt-4-32k-0613",
                }
# 返回的最小数据
re_chat = 1000

token_4 = 4000
token_16 = 8100
token_32 = 32000
model_max_token = {
    "gpt-3.5-turbo":token_4,
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
    models = []
    models.append({"0": "gpt-3.5-turbo-0613"})
    models.append({"1": "gpt-3.5-turbo-16k-0613"})
    models.append({"2": "gpt-4-0613"})
    models.append({"3": "gpt-4-32k-0613"})
    return get_all_model


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
