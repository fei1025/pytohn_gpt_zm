from langchain_core.utils.function_calling import convert_to_openai_function, convert_to_openai_tool
from openai import OpenAI

import json

from openai.types.chat import ChatCompletionMessageToolCall
from openai.types.chat.chat_completion_chunk import ChoiceDeltaToolCallFunction

from Util.MyWolfram import MyWolframAlphaAPIWrapper, MyWolframAlphaQueryRun

openai_api_key = 'sb-48ce6279f88e82c385dfc0a1d0feb964f4ea485874f9aeb9'
openai_api_base="https://api.openai-sb.com/v1"
#openai_api_base="https://us.qaqgpt.com/v1"
#openai_api_key = 'sk-rdPkgBdWgdSnxSLN5f72Da3bF212450c9394629d8f280005'

client = OpenAI(base_url=openai_api_base,api_key=openai_api_key)
#Choice(delta=ChoiceDelta(content='', function_call=None, role='assistant', tool_calls=None), finish_reason=None, index=0, logprobs=None)
#Choice(delta=ChoiceDelta(content=None, function_call=None, role=None, tool_calls=[ChoiceDeltaToolCall(index=0, id=None, function=ChoiceDeltaToolCallFunction(arguments='sco"}', name=None), type=None)]), finish_reason=None, index=0, logprobs=None)
# ChatCompletionMessage(content=None, role='assistant', function_call=None, tool_calls=[ChatCompletionMessageToolCall(id='call_VHsknRr8FYyLYQLGNncpgZ29', function=Function(arguments='{"__arg1": "10 densest elemental metals"}', name='wolfram_alpha'), type='function'), ChatCompletionMessageToolCall(id='call_hKNwGH1KhTiJvfRpTkg9rhE4', function=Function(arguments='{"__arg1": "densest elemental metals"}', name='wolfram_alpha'), type='function')])

# Example dummy function hard coded to return the same weather
# In production, this could be your backend API or an external API

def get_current_weather(location, unit="fahrenheit"):

    """Get the current weather in a given location"""
    if "tokyo" in location.lower():
        return json.dumps({"location": "Tokyo", "temperature": "10", "unit": unit})
    elif "san francisco" in location.lower():
        return json.dumps({"location": "San Francisco", "temperature": "72", "unit": unit})
    elif "paris" in location.lower():
        return json.dumps({"location": "Paris", "temperature": "22", "unit": unit})
    else:
        return json.dumps({"location": location, "temperature": "unknown"})

def run_conversation():
    wolfram = MyWolframAlphaAPIWrapper(wolfram_alpha_appid="5V6ELP-UUPQLEAUXU")
    query_run = MyWolframAlphaQueryRun(api_wrapper=wolfram, tags=['a-tag'], )
    # Step 1: send the conversation and available functions to the model
    #messages = [{"role": "user", "content": "What's the weather like in San Francisco, Tokyo, and Paris?"}]
    messages = [{"role": "user", "content": "10+densest+elemental+metals"}]
    tools = [
        {
            "type": "function",
            "function": {
                "name": "get_current_weather",
                "description": "Get the current weather in a given location",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "location": {
                            "type": "string",
                            "description": "The city and state, e.g. San Francisco, CA",
                        },
                        "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]},
                    },
                    "required": ["location"],
                },
            },
        }
    ]
    print(convert_to_openai_tool(query_run))
    tools.append(convert_to_openai_tool(query_run))
    response = client.chat.completions.create(
        model="gpt-3.5-turbo-1106",
        messages=messages,
        tools=tools,
        tool_choice="auto",  # auto is default, but we'll be explicit
        #
       # stream=True
    )
    s=""
    toolList=[]
    content=""
    i1=0
    for i in response:
        if i1 == 0:
            i1 = i1 + 1
            continue
        print(i)
        if i.choices[0].delta.tool_calls:
            tool_calls = i.choices[0].delta.tool_calls[0]
            if tool_calls.function.name and tool_calls.function.name != '':
                tool_name = tool_calls.function.name

                curFunction = ChatCompletionMessageToolCall()
                curFunction.function.name = tool_calls.function.name
                curFunction.function.arguments = tool_calls.function.arguments
                toolList.append(curFunction)
            else:
                curFunction = toolList[tool_calls.index]
                curFunction.arguments = curFunction.function.arguments + tool_calls.function.arguments

        else:
            if i.choices[0].delta.content:
                content = content + i.choices[0].delta.content
    print("#####################################")
    print(toolList)
    for i in response:
        print("-------------------------")
        # 确保 i.choices 是非空列表
        print( i.choices)
        if i.choices:
            # 确保 choices[0] 存在
            if i.choices[0]:
                # 获取 tool_calls 对象
                tool_calls = i.choices[0].delta.tool_calls

                if tool_calls:
                    print(tool_calls)
                    print(tool_calls[0].function.arguments)
                    print(tool_calls[0].function.name)
                    s=s+tool_calls[0].function.arguments
                else:
                    print("找不到tool_calls对象")
            else:
                print("choices[0] 不存在")
        else:
            print("choices 列表为空")
    print("########################")
    print(s)
    return
    response_message = response.choices[0].message
    print("---------------------------------------------------------")
    print(response_message)

    tool_calls = response_message.tool_calls
    # Step 2: check if the model wanted to call a function
    if tool_calls:
        # Step 3: call the function
        # Note: the JSON response may not always be valid; be sure to handle errors
        available_functions = {
            "get_current_weather": get_current_weather,
            "wolfram_alpha":query_run.run
        }  # only one function in this example, but you can have multiple
        # ChatCompletionMessage(content=None, role='assistant', function_call=None, tool_calls=[ChatCompletionMessageToolCall(id='call_s2RPC1licGlT3DgajiSMcRJO', function=Function(arguments='{"__arg1": "10 densest elemental metals"}', name='wolfram_alpha'), type='function'), ChatCompletionMessageToolCall(id='call_qLw3y7htOm50OkY0mAPL4enK', function=Function(arguments='{"__arg1": "10 densest elemental metals images"}', name='wolfram_alpha'), type='function')])
        assistant_message = {
            "role": "assistant",
            "tool_calls": toolList,
            "content": None
        }
        messages.append(assistant_message)  # extend conversation with assistant's reply
        # Step 4: send the info for each function call and function response to the model
        for tool_call in tool_calls:
            function_name = tool_call.function.name
            function_to_call = available_functions[function_name]
            function_args = json.loads(tool_call.function.arguments)
            # function_response = function_to_call(
            #     location=function_args.get("location"),
            #     unit=function_args.get("unit"),
            # )
            function_response = function_to_call(
                function_args.get("__arg1")
            )
            messages.append(
                {
                    "tool_call_id": tool_call.id,
                    "role": "tool",
                    "name": function_name,
                    "content": function_response,
                }
            )  # extend conversation with function response
        second_response = client.chat.completions.create(
            model="gpt-3.5-turbo-1106",
            messages=messages,
        )  # get a new response from the model where it can see the function response
        print("#######################")
        print(messages)
        return  second_response.choices[0].message.content
print("---------------------------------------------------")
print(run_conversation())