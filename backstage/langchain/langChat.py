import os
# 流输出
# https://blog.csdn.net/q506610466/article/details/132790633
from langchain.llms import OpenAI
from langchain.schema import HumanMessage

#openai.api_key = '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'
openai_api_key='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'
from langchain.chat_models import ChatOpenAI

# 设置HTTP代理的地址和端口
http_proxy = "http://127.0.0.1:7890"

# openAi的llm
llm = OpenAI(openai_api_key=openai_api_key,verbose=True,openai_proxy=http_proxy)
# 这是一个语言模型，它将消息列表作为输入并返回消息
chat_model = ChatOpenAI(openai_api_key=openai_api_key,verbose=True,openai_proxy=http_proxy)

text = "What would be a good company name for a company that makes colorful socks?"
messages = [HumanMessage(content=text)]

#print(chat_model.predict_messages(messages))
result = chat_model._stream(messages) # 这里会得到生成器
text = ""
for i in result:
    print(i)
    text = text+i.message.content

print(text)
