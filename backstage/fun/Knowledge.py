import hashlib
import logging
import os

from langchain.embeddings import OpenAIEmbeddings
from langchain import FAISS
from sqlalchemy.orm import Session

from langchain.document_loaders import PyPDFLoader
from entity import models, crud


# 创建一个知识库
def create_knowledge(knowledge: models.knowledge, db: Session):
    index_path = "./index/paper"
    embeddings = OpenAIEmbeddings(openai_api_base="https://api.openai-sb.com/v1",
                                  openai_api_key="sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9")
    file_src = knowledge.file_path
    documents = get_documents(file_src)
    index = FAISS.from_documents(documents, embeddings)
    # os.makedirs("./index", exist_ok=True)
    index_name = string_to_md5(file_src)
    index_path = index_path + "/" + index_name
    index.save_local(index_path)
    knowledge.index_name = index_name
    knowledge.index_path = index_path
    crud.save_knowledge(db, knowledge)


def add_knowledge(knowledge: models.knowledge, db: Session):
    index_path = knowledge.index_path
    pass


def get_documents(filepath):
    documents = []
    from langchain.text_splitter import TokenTextSplitter
    text_splitter = TokenTextSplitter(chunk_size=500, chunk_overlap=30)
    filename = os.path.basename(filepath)
    file_type = os.path.splitext(filename)[1]
    texts = None
    if file_type == ".pdf":
        loader = PyPDFLoader(filepath)
        texts = loader.load()
    elif file_type == ".docx":
        logging.debug("Loading Word...")
        from langchain.document_loaders import UnstructuredWordDocumentLoader
        loader = UnstructuredWordDocumentLoader(filepath)
        texts = loader.load()
    elif file_type == ".pptx":
        logging.debug("Loading PowerPoint...")
        from langchain.document_loaders import UnstructuredPowerPointLoader
        loader = UnstructuredPowerPointLoader(filepath)
        texts = loader.load()
    elif file_type == ".epub":
        logging.debug("Loading EPUB...")
        from langchain.document_loaders import UnstructuredEPubLoader
        loader = UnstructuredEPubLoader(filepath)
        texts = loader.load()
    else:
        logging.debug("Loading text file...")
        from langchain.document_loaders import TextLoader
        loader = TextLoader(filepath, "utf8")
        texts = loader.load()
    if texts is not None:
        texts = text_splitter.split_documents(texts)
        documents.extend(texts)
    return documents


def string_to_md5(string):
    # 创建 MD5 对象
    md5_hash = hashlib.md5()
    # 更新对象中的字符串
    md5_hash.update(string.encode('utf-8'))
    # 获取 MD5 哈希值
    md5_value = md5_hash.hexdigest()
    return md5_value
