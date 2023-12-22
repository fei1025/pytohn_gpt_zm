import hashlib
import os

from langchain.embeddings import OpenAIEmbeddings
from langchain import FAISS

from sqlalchemy.orm import Session
from entity import crud
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.document_loaders import PyPDFLoader



# 创建一个知识库
def create_Konwledge():
    # db: Session
    index_path = "./index/paper"
    #setting = crud.get_user_setting(db)
    #embeddings = OpenAIEmbeddings(openai_api_base=setting.openai_api_base,openai_api_key=setting.openai_api_key,model="gpt-3.5-turbo")
    embeddings = OpenAIEmbeddings(openai_api_base="https://api.openai-sb.com/v1",openai_api_key="sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9")

    loader = PyPDFLoader("../paper.pdf")
    data = loader.load()
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=0)
    all_splits = text_splitter.split_documents(data)
    documents = []
    documents.extend(all_splits)
    index = FAISS.from_documents(documents, embeddings)
    os.makedirs("./index", exist_ok=True)
    index.save_local(index_path)
    pass




def string_to_md5(string):
    # 创建 MD5 对象
    md5_hash = hashlib.md5()
    # 更新对象中的字符串
    md5_hash.update(string.encode('utf-8'))
    # 获取 MD5 哈希值
    md5_value = md5_hash.hexdigest()
    return md5_value


create_Konwledge()