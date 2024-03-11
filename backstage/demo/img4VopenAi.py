import os
from math import ceil
from PIL import Image

from openai import OpenAI
import json
import tiktoken

from demo.tokenDemo01 import calculate_image_tokens

# Set up OpenAI API key
#openai.api_key = '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'
# openai.api_key = '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'
#openai.api_key = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'
#openai.api_base="https://api.openai-sb.com/v1"

#openai_api_base="https://api.openai-sb.com/v1"
#openai_api_key = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'
openai_api_base="https://api.qaqgpt.com/v1"
openai_api_key = 'sk-Jc7qzfs6qLsDADYkAfC9Ac0cDe5c426e9c2134580aFd67E1'
import base64

def image_to_base64(image_path):
    with open(image_path, "rb") as image_file:
        encoded_image = base64.b64encode(image_file.read())
        return encoded_image.decode('utf-8')




# Function to send a message to the OpenAI chatbot model and return its response
def send_message(message_log):
    # print(f'The message_log is {message_log}')

    # Use OpenAI's ChatCompletion API to get the chatbot's response

    client = OpenAI(base_url=openai_api_base, api_key=openai_api_key)

    response = client.chat.completions.create(
        model="gpt-3.5-turbo-1106",
        messages=message_log,
        tool_choice="auto",  # auto is default, but we'll be explicit
        # stream=True
    )
    # Find the first response from the chatbot that has text in it (some responses may not have text)
    print(f"Neko: {response}")
    print("--------------------------")
    for choice in response.choices:
        if "text" in choice:
            return choice.text

    # 流输出
    # for chunk in response:
    #         # 在这里处理API响应的块数据
    #         print(chunk)
    #
    # # 结束流式传输API调用
    # response.stop()

    # If no response with text is found, return the first response's content (which may be empty)
    return response.choices[0].message.content


# Main function that runs the chatbot
def gpt4v(query,imgurl):
    #image_path = "D:\\data\\xxxhdpi.png"
    #base64_string = image_to_base64(image_path)
    # resp = openai.ChatCompletion.create(
    #     model="gpt-4-vision-preview",
    #     messages=[
    #         {
    #             "role": "user",
    #             "content": [
    #                 {"type": "text", "text": query},
    #                 {
    #                     "type": "image_url",
    #                     "image_url":imgurl,
    #                 },
    #             ],
    #         }
    #     ],
    #     max_tokens=2086,
    # )
    client = OpenAI(base_url=openai_api_base, api_key=openai_api_key)

    response = client.chat.completions.create(
        model="gpt-4-vision-preview",
        messages=[
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": query},
                    {
                        "type": "image_url",
                        "image_url":imgurl,
                    },
                ],
            }
        ],
        max_tokens=1,
        # stream=True
    )

    print(response)
    print(response.choices[0].message.content)
# ChatCompletion(id='chatcmpl-91TlFSpbUDcPXSKqBu34m7LsJTVfn', choices=[Choice(finish_reason='stop', index=0, logprobs=None, message=ChatCompletionMessage(content='由于图片中的文本是中文的，并且包含具体的元素和布局，可以根据图片内容创建一个简单的HTML界面。以下是根据图片内容编写的一个简单的HTML页面框架:\n\n```html\n<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width, initial-scale=1.0">\n<title>页面示例</title>\n<style>\n  body {\n    font-family: \'Arial\', sans-serif;\n    background-color: #4c7ef3; /* 可以根据图片调整背景色 */\n    color: #ffffff;\n    text-align: center;\n    margin: 0;\n    padding: 50px; /* 添加一些内边距 */\n  }\n  .container {\n    background-color: #4c7ef3; /* 确保容器背景同页面背景色相同 */\n    border-radius: 8px;\n    padding: 20px;\n    max-width: 600px;\n    margin: auto;\n  }\n  input[type="text"], button {\n    margin: 10px 0;\n    padding: 10px;\n    border-radius: 5px;\n    border: none;\n    width: 80%; /* 输入框宽度 */\n  }\n  button {\n    background-color: #007bff; /* 按钮背景色 */\n    color: white;\n    font-size: 16px;\n    cursor: pointer;\n  }\n</style>\n</head>\n<body>\n<div class="container">\n  <h1>山中有限公司</h1>\n  <h2>次仁通档案</h2>\n  <label for="serial-number">手机后4位:</label>\n  <input type="text" id="serial-number" name="serial-number" placeholder="输入人选：#0000">\n  <label for="range">篮筹:</label>\n  <input type="text" id="range" name="range" placeholder="1-389范围">\n  <button type="submit">确认提交</button>\n</div>\n</body>\n</html>\n```\n\n这个HTML页面提供了一个输入手术后4位序列号的文本框，一个输入篮筹范围的文本框，和一个确认提交的按钮。样式只是基于图片内容的简单示例，实际页面会需要更精细的调整以达到设计要求。\n\n请根据具体需要执行样式和逻辑的调整。', role='assistant', function_call=None, tool_calls=None))], created=1710139757, model='gpt-4-1106-vision-preview', object='chat.completion', system_fingerprint=None, usage=CompletionUsage(completion_tokens=593, prompt_tokens=1126, total_tokens=1719))
def image_to_base64(image_path):
    with open(image_path, "rb") as img_file:
        # 读取图片文件并将其编码为Base64
        base64_image = base64.b64encode(img_file.read()).decode('utf-8')
        return base64_image
DIRECTLY_SUPPORTED_IMAGE_FORMATS = (".png", ".jpeg", ".gif", ".webp") # image types that can be directly uploaded, other formats will be converted to jpeg
IMAGE_FORMATS = DIRECTLY_SUPPORTED_IMAGE_FORMATS + (".jpg", ".bmp", "heic", "heif") # all supported image formats

def get_image_type(image_path):
        if image_path.lower().endswith(DIRECTLY_SUPPORTED_IMAGE_FORMATS):
            return os.path.splitext(image_path)[1][1:].lower()
        else:
            return "jpeg"

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
            if isinstance(value, list):
                for message1 in value:
                    for key1,value1 in message1.items():
                        if key1=="image_url":
                            width, height = get_image_dimensions_from_base64(value1.split(";base64,")[1])
                            print(width, height)
                            print(num_tokens)
                            print(calculate_image_tokens(width, height)["totalTokens"])
                            num_tokens += calculate_image_tokens(width, height,True)["totalTokens"]
                        else:
                            num_tokens += len(encoding.encode(value1))

                continue
            num_tokens += len(encoding.encode(value))
            if key == "name":
                num_tokens += tokens_per_name
    num_tokens += 3  # every reply is primed with <|start|>assistant<|message|>
    return num_tokens




def count_image_tokens( width: int, height: int):
        h = ceil(height / 512)
        w = ceil(width / 512)
        n = w * h
        total = 85 + 170 * n
        return total

def get_image_dimensions_from_base64(base64_string):
    # 解码base64字符串
    image_data = base64.b64decode(base64_string)

    # 将字节数据转换为内存中的图像对象
    import io
    image = Image.open(io.BytesIO(image_data))

    # 获取图像宽度和高度
    width, height = image.size

    return width, height

# Call the main function if this file is executed directly (not imported as a module)
if __name__ == "__main__":
    # 用法示例
    # image_path = "D:\\data\\xxxhdpi.png"
    # base64_string = image_to_base64(image_path)
    # print(base64_string)
    # gpt4v("根据这个图片,给我一画一个html页面")
    # data  = image_to_base64("D:\\data\\xxxhdpi.png")
    image="D:\\data\\xxxhdpi.png"

    imgurl =f"data:image/{get_image_type(image)};base64,{image_to_base64(image)}"
    print(imgurl.split(";base64,")[1]==image_to_base64(image))
    image = Image.open(image)

    # 获取图像宽度和高度
    width, height = image.size
    print( width, height )
    # (7680, 4320)
    print(get_image_dimensions_from_base64(imgurl.split(";base64,")[1]))
    # print(imgurl)
    #gpt4v("根据这个图片,给我画一个html页面",imgurl)
    # 完成=501, 提示=106, 总共=600)
    # 完成 593   提示1126  总共1719
    #completion_tokens=593, prompt_tokens=1126, total_tokens=1719)
    messages = [
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "根据这个图片,给我画一个html页面"},
                {
                    "type": "image_url",
                    "image_url": imgurl,
                },
            ],
        }
    ]
    print(num_tokens_from_messages(messages=messages))
   # print(count_token(aa))
    # main()

