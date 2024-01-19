import os
# 流输出
# https://blog.csdn.net/q506610466/article/details/132790633
from langchain_community.llms import OpenAI
from langchain.schema import HumanMessage
from langchain.memory import ConversationSummaryMemory


#openai.api_key = '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'
#openai_api_key=   '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'
openai_api_key = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'

from langchain_community.chat_models.openai import ChatOpenAI

# 设置HTTP代理的地址和端口
http_proxy = "http://127.0.0.1:3208"
# sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9
# openAi的llm
#llm = OpenAI(openai_api_key=openai_api_key,verbose=True,openai_api_base="https://api-cf.openai-sb.com/v1/chat/completions")
# 这是一个语言模型，它将消息列表作为输入并返回消息
chat_model = ChatOpenAI(openai_api_key=openai_api_key,verbose=True,openai_api_base="https://api.openai-sb.com/v1",streaming=True)
text = "What would be a good company name for a company that makes colorful socks?"
messages = [HumanMessage(content=text)]
def get_chat():
    # print(chat_model.predict_messages(messages))
     return chat_model._stream(messages)  # 这里会得到生成器

