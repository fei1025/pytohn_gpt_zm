#  请求参数 {'location': 'Paris, France', 'unit': 'celsius'}
import requests
from tqdm import tqdm


class dalle_3:
    def __init__(self):
        pass
    def text2image(self,**kwargs):
        prompt=kwargs['prompt']
        style=kwargs['style']
        size=kwargs['size']
        quality=kwargs['quality']
        headers = {
            "Content-Type": "application/json",
            "Authorization": "Bearer sk-Jc7qzfs6qLsDADYkAfC9Ac0cDe5c426e9c2134580aFd67E1",
        }
        data = {
            "model": "dall-e-3",
            "prompt": prompt,
            "n": 1,
            "size": size,
            "style":style,
            "quality":quality
        }
        response = requests.post(url, headers=headers, json=data)
        print(response.headers)
        # {'created': 1711116467, 'data': [{'revised_prompt': 'Create a distinctive icon featuring elements related to mathematics such as equations, balance scales, compasses, and rulers. The overall image should convey a sense of logic, precision, and complexity. The background should be transparent, and the icon should be designed in a way that allows it to be easily recognizable even when scaled down. The primary colors should be those traditionally associated with mathematics and education: blue for logic, green for growth, and white for clarity.', 'url': 'https://oaidalleapiprodscus.blob.core.windows.net/private/org-4ZEA4qzYvP9ibb11UrLszJyj/user-4uZfivMZBym9lXJZKyNMXAgO/img-nKAk71ZwWb7XhVF27HWSHs20.png?st=2024-03-22T13%3A07%3A47Z&se=2024-03-22T15%3A07%3A47Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-03-21T21%3A05%3A43Z&ske=2024-03-22T21%3A05%3A43Z&sks=b&skv=2021-08-06&sig=8EoHm6qnTqF8Ir5UcR8XFSeiQjC4EXKduBrfaDeklpY%3D'}]}
        # Check the response
        if response.status_code == 200:

            result = response.json()
            print(result.data)
        else:
            print(f"Error: {response.status_code}, {response.text}")
    def download_image(self,url, filename):
        # 发送GET请求以获取图像内容
        response = requests.get(url, stream=True)

        # 检查响应状态码是否为200（表示成功）
        if response.status_code == 200:
            # 获取文件大小
            total_size = int(response.headers.get('content-length', 0))
            # 创建一个进度条，并设置文件大小
            progress_bar = tqdm(total=total_size, unit='B', unit_scale=True)

            # 以二进制模式写入图像内容到文件
            with open(filename, 'wb') as f:
                for chunk in response.iter_content(chunk_size=1024):
                    if chunk:
                        f.write(chunk)
                        #chunk 就是1024 设置的这个数据
                        print(f"总数据:{total_size},当前数据:{len(chunk)}")
                        progress_bar.update(len(chunk))  # 更新进度条
            progress_bar.close()
            print("Image downloaded successfully")
        else:
            print("Failed to download image")




aa={"bb":dalle_3()}
dd={'location': 'Paris, France', 'unit': 'celsius'}
instance =aa['bb']
# 要调用的方法名称
method_name = "text2image"
url="https://oaidalleapiprodscus.blob.core.windows.net/private/org-4ZEA4qzYvP9ibb11UrLszJyj/user-4uZfivMZBym9lXJZKyNMXAgO/img-nKAk71ZwWb7XhVF27HWSHs20.png?st=2024-03-22T13%3A07%3A47Z&se=2024-03-22T15%3A07%3A47Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-03-21T21%3A05%3A43Z&ske=2024-03-22T21%3A05%3A43Z&sks=b&skv=2021-08-06&sig=8EoHm6qnTqF8Ir5UcR8XFSeiQjC4EXKduBrfaDeklpY%3D"

dalle_3().download_image(url,"img11.jpg")
# 获取方法
#method = getattr(instance, method_name)(**dd)

# 调用方法


