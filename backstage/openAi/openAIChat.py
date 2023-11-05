from sqlalchemy.orm import Session

from entity import crud
from entity.schemas import reqChat


def send_open_ai(db: Session, res: reqChat):
    # 获取历史聊天记录
    message = get_history(db, res)
    pass


def get_history(db: Session, res: reqChat) -> list:
    chat_id = res.chat_id
    chatHistList = crud.get_chat_hist_details(db, chat_id)
    message = []
    for chat in chatHistList:
        message.append({"role": chat.role, "content": chat.content})
    return message
