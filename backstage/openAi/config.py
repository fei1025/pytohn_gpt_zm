import os

from contextlib2 import contextmanager

import db.database
from entity import crud


@contextmanager
def retrieve_proxy(proxy=None):
    """
    1, 如果proxy = NONE，设置环境变量，并返回最新设置的代理
    2，如果proxy ！= NONE，更新当前的代理配置，但是不更新环境变量
    """
    setting = crud.get_user_setting(db.database.get_db())
    global http_proxy, https_proxy
    if setting is not None and setting.http_proxy is not None:
        proxy = setting.http_proxy
        http_proxy = proxy
        https_proxy = proxy
        yield http_proxy, https_proxy
    else:
        old_var = os.environ["HTTP_PROXY"], os.environ["HTTPS_PROXY"]
        os.environ["HTTP_PROXY"] = http_proxy
        os.environ["HTTPS_PROXY"] = https_proxy
        yield http_proxy, https_proxy  # 返回新的代理
        # 返回旧的代理
        os.environ["HTTP_PROXY"], os.environ["HTTPS_PROXY"] = old_var  # 修复：将环境变量设置回原始值







