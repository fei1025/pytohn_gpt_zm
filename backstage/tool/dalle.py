#  请求参数 {'location': 'Paris, France', 'unit': 'celsius'}
import os
import uuid
import json

import requests

dalle_3fu = {
    "name": "lobe_image_designer",
    "description": "The user 's original image description, potentially modified to abide by the "
                   "lobe-image-designer policies. If the user does not suggest a number of captions to create, "
                   "create four of them. If creating multiple captions, make them as diverse as possible. If the "
                   "user requested modifications to previous images, the captions should not simply be longer, "
                   "but rather it should be refactored to integrate the suggestions into each of the captions. "
                   "Generate no more than 4 images, even if the user requests more.",
    "parameters": {
        "type": "object",
        "required": ['prompts'],
        "properties": {
            "prompt": {
                "type": "string",
                "description": "The user 's original image description, potentially modified to abide by the "
                               "lobe-image-designer policies."
            },
            "quality": {
                "type": "string",
                "default": 'standard',
                "description": "The quality of the image that will be generated. hd creates images with finer "
                               "details and greater consistency across the image."
            },
            "size": {
                "default": '1024x1024',
                "description": "The resolution of the requested image, which can be wide, square, or tall. Use 1024x1024 (square) as the default unless the prompt suggests a wide image, 1792x1024, or a full-body portrait, in which case 1024x1792 (tall) should be used instead. Always include this parameter in the request.",
                "enum": ['1792x1024', '1024x1024', '1024x1792'],
            },
            "style": {
                "default": "vivid",
                "description": "The style of the generated images. Must be one of vivid or natural. Vivid causes the model to lean towards generating hyper-real and dramatic images. Natural causes the model to produce more natural, less hyper-real looking images.",
                "enum": ['vivid', 'natural'],
                "type": 'string',
            }
        }
    }
}


class dalle_3:
    target_dir = 'img'
    url = "https://api.qaqgpt.com/v1/images/generations"

    def __init__(self):
        pass

    def lobe_image_designer(self, **kwargs):
        prompt = kwargs['prompt']
        style = kwargs['style']
        size = kwargs['size']
        quality = kwargs['quality']
        headers = {
            "Content-Type": "application/json",
            "Authorization": "Bearer sk-E6Vzqjqqcpxhr2BlAfEeA70b70774623B412A4C542C69d65",
        }
        data = {
            "model": "dall-e-3",
            "prompt": prompt,
            "n": 1,
            "size": size,
            "style": style,
            "quality": quality
        }
        response = requests.post(self.url, headers=headers, json=data)
        print(response.headers)
        # {'created': 1711116467, 'data': [{'revised_prompt': 'Create a distinctive icon featuring elements related to mathematics such as equations, balance scales, compasses, and rulers. The overall image should convey a sense of logic, precision, and complexity. The background should be transparent, and the icon should be designed in a way that allows it to be easily recognizable even when scaled down. The primary colors should be those traditionally associated with mathematics and education: blue for logic, green for growth, and white for clarity.', 'url': 'https://oaidalleapiprodscus.blob.core.windows.net/private/org-4ZEA4qzYvP9ibb11UrLszJyj/user-4uZfivMZBym9lXJZKyNMXAgO/img-nKAk71ZwWb7XhVF27HWSHs20.png?st=2024-03-22T13%3A07%3A47Z&se=2024-03-22T15%3A07%3A47Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-03-21T21%3A05%3A43Z&ske=2024-03-22T21%3A05%3A43Z&sks=b&skv=2021-08-06&sig=8EoHm6qnTqF8Ir5UcR8XFSeiQjC4EXKduBrfaDeklpY%3D'}]}
        # Check the response
        if response.status_code == 200:
            result = response.json()
            images = result['data']
            img_list = []
            for img in images:
                if not os.path.exists(self.target_dir):
                    os.makedirs(self.target_dir)
                file_uuid = uuid.uuid4()
                target_image_path = os.path.join(self.target_dir, f'{file_uuid}.jpg')
                img_url = img['url']
                self.download_image(img_url, target_image_path)
                img_list.append(target_image_path)
            print(f"img_list{img_list}")
            return json.dumps(img_list)
        else:
            print(f"Error: {response.status_code}, {response.text}")

    def download_image(self, url, filename):
        # 发送GET请求以获取图像内容
        response = requests.get(url, stream=True)

        # 检查响应状态码是否为200（表示成功）
        if response.status_code == 200:
            # 获取文件大小
            total_size = int(response.headers.get('content-length', 0))
            # 创建一个进度条，并设置文件大小
            # progress_bar = tqdm(total=total_size, unit='B', unit_scale=True)

            # 以二进制模式写入图像内容到文件
            with open(filename, 'wb') as f:
                for chunk in response.iter_content(chunk_size=1024):
                    if chunk:
                        f.write(chunk)
                        # chunk 就是1024 设置的这个数据
                        print(f"总数据:{total_size},当前数据:{len(chunk)}")
                        # progress_bar.update(len(chunk))  # 更新进度条
            # progress_bar.close()

            print("Image downloaded successfully")
        else:
            print("Failed to download image")

# aa={"bb":dalle_3()}
# dd={'location': 'Paris, France', 'unit': 'celsius'}
# instance =aa['bb']
# # 要调用的方法名称
# method_name = "text2image"
# url="https://oaidalleapiprodscus.blob.core.windows.net/private/org-4ZEA4qzYvP9ibb11UrLszJyj/user-4uZfivMZBym9lXJZKyNMXAgO/img-nKAk71ZwWb7XhVF27HWSHs20.png?st=2024-03-22T13%3A07%3A47Z&se=2024-03-22T15%3A07%3A47Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-03-21T21%3A05%3A43Z&ske=2024-03-22T21%3A05%3A43Z&sks=b&skv=2021-08-06&sig=8EoHm6qnTqF8Ir5UcR8XFSeiQjC4EXKduBrfaDeklpY%3D"
#
# dalle_3().download_image(url,"img11.jpg")
# # 获取方法
# method = getattr(instance, method_name)(**dd)

# 调用方法
