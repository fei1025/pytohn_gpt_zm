import openai
from sqlalchemy.orm import Session

from entity import crud
from entity.openAi_entity import TrimMessagesInput
from entity.schemas import reqChat
import openAiUtil
from openAi.config import retrieve_proxy


def send_open_ai(db: Session, res: reqChat):
    # 获取历史聊天记录
    message: list = get_history(db, res)
    setting = crud.get_user_setting(db)

    trim_mess = TrimMessagesInput()
    trim_mess.messages = message
    trim_mess.model = openAiUtil.get_open_model(res.modle)
    messageNum = openAiUtil.trim_messages(trim_mess)
    max_token = openAiUtil.get_max_tokens(openAiUtil.get_open_model(res.modle)) - messageNum.num
    with retrieve_proxy:
        response = openai.ChatCompletion.create(
            model=res.model,  # The name of the OpenAI chatbot model to use
            messages=messageNum.messages,  # The conversation history up to this point, as a list of dictionaries
            max_tokens=max_token,  # The maximum number of tokens (words or subwords) in the generated response
            # 为什么这里改成4096就得崩？
            stop=None,  # The stopping sequence for the generated response, if any (not used here)
            temperature=res.temperature,  # The "creativity" of the generated response (higher temperature = more creative)
            stream=True
    )
        return response




def set_max_token():
    pass


def get_history(db: Session, res: reqChat) -> list:
    chat_id = res.chat_id
    chatHistList = crud.get_chat_hist_details(db, chat_id)
    message = []
    for chat in chatHistList:
        message.append({"role": chat.role, "content": chat.content})
    return message
