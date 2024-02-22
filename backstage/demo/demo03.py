import requests

def query_wolfram_alpha(input_text, app_id):
    url = f"https://www.wolframalpha.com/api/v1/llm-api?input={input_text}&appid={app_id}"
    response = requests.get(url)
    if response.status_code == 200:
        return response.text
    else:
        print("Error:", response.status_code)

input_text = "10 densest elemental metals"
app_id = "5V6ELP-UUPQLEAUXU"

result = query_wolfram_alpha(input_text, app_id)
print(result)
