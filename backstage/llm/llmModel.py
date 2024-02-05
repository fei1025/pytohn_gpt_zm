import os
from abc import ABC
from asyncio import Condition
from collections import deque
from typing import Any, Dict, List, Optional, Union
from uuid import UUID

from langchain_community.utilities import WolframAlphaAPIWrapper
from langchain.agents import initialize_agent, AgentType
from langchain.callbacks import StdOutCallbackHandler
from langchain.callbacks.base import BaseCallbackHandler

# from langchain_community.chat_models import ChatOpenAI
from langchain_community.chat_models.openai import ChatOpenAI
from langchain.schema import LLMResult, AgentAction, AgentFinish
from langchain_community.tools import WolframAlphaQueryRun, format_tool_to_openai_function
from langchain.utils import print_text
from langchain_experimental.tools import PythonREPLTool


class CallbackToIterator:
    def __init__(self):
        self.queue = deque()
        self.cond = Condition()
        self.finished = False

    def callback(self, result):
        with self.cond:
            self.queue.append(result)
            self.cond.notify()  # Wake up the generator.

    def __iter__(self):
        return self

    def __next__(self):
        with self.cond:
            # Wait for a value to be added to the queue.
            while not self.queue and not self.finished:
                self.cond.wait()
            if not self.queue:
                raise StopIteration()
            return self.queue.popleft()

    def finish(self):
        with self.cond:
            self.finished = True
            self.cond.notify()  # Wake up the generator if it's waiting.


class MyCustomHandler(BaseCallbackHandler):
    def __init__(self, callback) -> None:
        """Initialize callback handler."""
        self.callback = callback

    def on_llm_new_token(self, token: str, **kwargs: Any) -> Any:
        print(f"on_new_token {token}")
        pass

    def on_llm_start(
            self, serialized: Dict[str, Any], prompts: List[str], **kwargs: Any
    ) -> Any:
        print(f"on_llm_start (I'm the second handler!!) {serialized}")
        print("on_llm_start")

    def on_llm_end(self, response: LLMResult, **kwargs: Any) -> None:
        """Do nothing."""
        print("on_llm_end")
        pass

    def on_llm_error(
            self, error: Union[Exception, KeyboardInterrupt], **kwargs: Any
    ) -> None:
        """Do nothing."""
        print("on_llm_error")
        pass

    def on_chain_start(
            self, serialized: Dict[str, Any], inputs: Dict[str, Any], **kwargs: Any
    ) -> None:
        """Print out that we are entering a chain."""
        class_name = serialized.get("name", serialized.get("id", ["<unknown>"])[-1])
        # print(f"\n\n\033[1m> Entering new {class_name} chain...\033[0m")
        print(f"on_chain_start{class_name};;;{serialized}")

    def on_chain_end(self, outputs: Dict[str, Any], **kwargs: Any) -> None:
        """Print out that we finished a chain."""
        # print("\n\033[1m> Finished chain.\033[0m")
        print("on_chain_end")

    def on_chain_error(
            self, error: Union[Exception, KeyboardInterrupt], **kwargs: Any
    ) -> None:
        """Do nothing."""
        print("on_chain_error")
        pass

    def on_tool_start(
            self,
            serialized: Dict[str, Any],
            input_str: str,
            **kwargs: Any,
    ) -> None:
        """Do nothing."""
        print(f"on_tool_start:{serialized}")
        pass

    def on_agent_action(
            self, action: AgentAction, color: Optional[str] = None, **kwargs: Any
    ) -> Any:
        """Run on agent action."""
        print(f"这里会显示调用的工具:{action.tool}")

        # print_text(action.log, color='red')
