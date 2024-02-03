from sqlalchemy.orm import Session

from entity import crud
from entity.openAi_entity import TrimMessagesInput
from entity.schemas import reqChat
from openAi import openAiUtil


def send_open_ai(db: Session, res: reqChat):
    # 获取历史聊天记录
    message: list = get_history(db, res)
    # 设置openAI key
    setting = crud.get_user_setting(db)


def get_history(db: Session, res: reqChat) -> list:
    chat_id = res.chat_id
    chatHistList = crud.get_chat_hist_details(db, chat_id)
    print(f"chatId:{chat_id}获取的历史记录:{chatHistList}")
    message = []
    for chat in chatHistList:
        message.append({"role": chat.role, "content": chat.content})
    return message
