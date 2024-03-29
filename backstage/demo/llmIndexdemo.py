import os
from abc import ABC
from typing import Any, Dict, List, Optional, Union
from uuid import UUID

from langchain import hub
from langchain.memory import ConversationBufferMemory
#from langchain_community.utilities import WolframAlphaAPIWrapper
from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper

from langchain.agents import initialize_agent, AgentType, AgentExecutor, create_openai_functions_agent,create_openai_tools_agent
from langchain.callbacks import StdOutCallbackHandler
from langchain.callbacks.base import BaseCallbackHandler

# from langchain_community.chat_models import ChatOpenAI
from langchain_community.chat_models.openai import ChatOpenAI
from langchain.schema import LLMResult, AgentAction, AgentFinish
from langchain_community.tools import WolframAlphaQueryRun, format_tool_to_openai_function
from langchain.utils import print_text
from langchain_core.messages import HumanMessage, AIMessage
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_experimental.tools import PythonREPLTool

os.environ['OPENAI_API_KEY'] = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'
os.environ['openai_api_base'] = 'https://api.openai-sb.com/v1'

# os.environ["WOLFRAM_ALPHA_APPID"] = "5V6ELP-UUPQLEAUXU"
openai_api_key = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'

wolfram = WolframAlphaAPIWrapper(wolfram_alpha_appid="5V6ELP-UUPQLEAUXU")


# print(wolfram.run("What is 2x+5 = -3x + 7?"))
# tools = load_tools(["wolfram-alpha"])


class MyCustomHandlerTwo(BaseCallbackHandler):
    def on_tool_start(
            self,
            serialized: Dict[str, Any],
            input_str: str,
            **kwargs: Any,
    ) -> None:
        """Do nothing."""
        print(f"on_tool_start{serialized}")
        pass

    def on_tool_error(
            self, error: Union[Exception, KeyboardInterrupt], **kwargs: Any
    ) -> None:
        """Do nothing."""
        print("on_tool_error")
        pass


class MyCustomHandlerTwo11(BaseCallbackHandler):
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
        print(f"on_chain_start:{class_name};;;{serialized}")

    def on_chain_end(self, outputs: Dict[str, Any], **kwargs: Any) -> None:
        """Print out that we finished a chain."""
        # print("\n\033[1m> Finished chain.\033[0m")
        print(f"on_chain_end outputs:{outputs}")

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
        print("调用工具开始-----------------------------------------------")
        print(f"这里会显示调用的工具:{action.tool}")
        print(f"这里会显示调用的log:{action.log}")
        print(f"这里会显示调用的tool_input:{action.tool_input}")
        print(f"这里会显示调用的to_json:{action.to_json()}")
        print("调用工具结束-----------------------------------------------")
        # print_text(action.log, color='red')

    def on_tool_end(
            self,
            output: str,
            color: Optional[str] = None,
            observation_prefix: Optional[str] = None,
            llm_prefix: Optional[str] = None,
            **kwargs: Any,
    ) -> None:
        print("on_tool_end")
        """If not the final action, print out observation."""
        # if observation_prefix is not None:
        #     print_text(f"\n这是啥:? {observation_prefix}")
        # print_text(output, color=color)
        # 这里会显示公里返回的数据
        print(f"\n 这是啥3 :{output}")
        # if llm_prefix is not None:
        #     print_text(f"\n这是啥111 {llm_prefix}")

    def on_tool_error(
            self, error: Union[Exception, KeyboardInterrupt], **kwargs: Any
    ) -> None:
        """Do nothing."""
        print("on_tool_error")
        pass

    def on_agent_finish(
            self, finish: AgentFinish, color: Optional[str] = None, **kwargs: Any
    ) -> None:
        """Run on agent end."""
        print(f"finish.log:{finish.log}")
        print(f"finish.return_values:{finish.return_values}")



# handler = StdOutCallbackHandler()
# ,callbacks=[MyCustomHandlerTwo()]
query_run = WolframAlphaQueryRun(api_wrapper=wolfram, tags=['a-tag'])

tools = [query_run,PythonREPLTool()]

llm = ChatOpenAI(model_name="gpt-3.5-turbo", temperature=0, streaming=True, )

prompt = hub.pull("hwchase17/openai-tools-agent")


# agent = create_openai_tools_agent(llm, tools, prompt)
# agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)
#
#
# res = agent_executor.invoke(
#     {
#         "input": "体重为 72 公斤，以 4 英里每小时的速度，走路 45 分钟后的心率、卡路里消,用中文回复",
#         "chat_history": [
#             HumanMessage(content="hi! my name is bob"),
#             AIMessage(content="Hello Bob! How can I assist you today?"),
#         ],
#     }
# )
# print(res)
# print(res["output"])

# #print(s)
memory = ConversationBufferMemory(memory_key="chat_history")
#
agent = initialize_agent(tools, llm, agent=AgentType.STRUCTURED_CHAT_ZERO_SHOT_REACT_DESCRIPTION,memory=memory)
#agent = initialize_agent(tools, llm, agent=AgentType.CONVERSATIONAL_REACT_DESCRIPTION,memory=memory,verbose=True,callbacks=[MyCustomHandlerTwo11()])
# print(agent.run(input="你好"))
# print(agent.run(input="我第一句话问的什么"))
# print(agent.run(input="体重为 72 公斤，以 4 英里每小时的速度，走路 45 分钟后的心率、卡路里消,用中文回复"))
# print("----------------------------------------------------------")
# for chunk in agent.stream({"input": "你好", "chat_history": [],"callbacks":[MyCustomHandlerTwo11()]}):
#     print(chunk)
#     # if chunk.content is not None:
#     #     content = content + chunk.content

# logfile = "output.log"
# callbacks=[MyCustomHandlerTwo()] What is 2x+5 = -3x + 7?
#reply = agent.run(input="2 * 2 * 0.13 - 1.001? 如何计算,用中文回复" ,callbacks=[MyCustomHandlerTwo11()])
#reply = agent.run(input="体重为 72 公斤，以 4 英里每小时的速度，走路 45 分钟后的心率、卡路里消耗,用中文回复" ,)
# reply = agent.run(input="population%20france。,用中文回复" ,callbacks=[MyCustomHandlerTwo11()])
#memory = ConversationBufferMemory(memory_key="chat_history")
# memory.chat_memory.add_user_message("hi!")
# memory.chat_memory.add_ai_message("what's up?")
# chatHistory = []
# chatHistory.append(HumanMessage(content="你好"))
# chatHistory.append(HumanMessage(content="有什么可以帮助你的吗"))


#reply = agent.run(input="我第一句问的什么?", callbacks=[MyCustomHandlerTwo11()], memory=memory)
#print("--------------------------------------------------------------")
#print(reply)
# logger.info(reply)
