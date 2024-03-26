import os
import json
import openai
from base64 import b64decode
from pathlib import Path
# {'created': 1709524224, 'data': [{'revised_prompt': 'Design an icon that represents the subject of mathematical logic, commonly known as llm-math. The icon should have symbols or elements related to this discipline of mathematics. The background of the icon is to be transparent, allowing it to seamlessly blend with any surface it is placed on. Keep in mind that the icon needs to be simple and visually appealing, yet descriptive of the subject matter. The file format should be PNG.', 'url': 'https://oaidalleapiprodscus.blob.core.windows.net/private/org-ZpMbyjXqwAFa2ruHtSQIbziA/user-u6OXfqYBD6xsD39zybnRxycA/img-I8vyIi3seK6tWMdxjYizPc32.png?st=2024-03-04T02%3A50%3A24Z&se=2024-03-04T04%3A50%3A24Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-03-03T08%3A03%3A49Z&ske=2024-03-04T08%3A03%3A49Z&sks=b&skv=2021-08-06&sig=wJs1r7iR3GBiz3CILO7u2m9Gashls/BZmlpgDsoyIs8%3D'}]}
# 提示词
PROMPT = "Create an icon based on llm-math with a transparent png image as the background"

#openai.api_key = "sk-E6Vzqjqqcpxhr2BlAfEeA70b70774623B412A4C542C69d65"
#openai.api_base = "https://api.qaqgpt.com/v1"
import requests


url = "https://api.qaqgpt.com/v1/images/generations"
#url = "https://api.openai-sb.com/v1/images/generations"
headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer sk-Jc7qzfs6qLsDADYkAfC9Ac0cDe5c426e9c2134580aFd67E1",
}

data = {
    "model": "dall-e-3",
    "prompt":PROMPT,
    "n": 1,
    "size": "1024x1024",
}

response = requests.post(url, headers=headers, json=data)
print(response.headers)
# {'created': 1711116467, 'data': [{'revised_prompt': 'Create a distinctive icon featuring elements related to mathematics such as equations, balance scales, compasses, and rulers. The overall image should convey a sense of logic, precision, and complexity. The background should be transparent, and the icon should be designed in a way that allows it to be easily recognizable even when scaled down. The primary colors should be those traditionally associated with mathematics and education: blue for logic, green for growth, and white for clarity.', 'url': 'https://oaidalleapiprodscus.blob.core.windows.net/private/org-4ZEA4qzYvP9ibb11UrLszJyj/user-4uZfivMZBym9lXJZKyNMXAgO/img-nKAk71ZwWb7XhVF27HWSHs20.png?st=2024-03-22T13%3A07%3A47Z&se=2024-03-22T15%3A07%3A47Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-03-21T21%3A05%3A43Z&ske=2024-03-22T21%3A05%3A43Z&sks=b&skv=2021-08-06&sig=8EoHm6qnTqF8Ir5UcR8XFSeiQjC4EXKduBrfaDeklpY%3D'}]}
# Check the response
if response.status_code == 200:

    result = response.json()
    print(result)
else:
    print(f"Error: {response.status_code}, {response.text}")
