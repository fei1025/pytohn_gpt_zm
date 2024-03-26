import requests
import json


url="https://api.qaqgpt.com/v1/chat/completions"
api_key = 'sk-E6Vzqjqqcpxhr2BlAfEeA70b70774623B412A4C542C69d65'

headers = {
    "Authorization": f"Bearer {api_key}",
    "Content-Type": "application/json",
}
# 太贵了 1张图 1快5
data = {
    "model": "mj-chat",
    "stream": False,
    "messages": [
        {
            "role": "user",
            "content": "```json\n{\n  \"type\": \"imagine\",\n  \"prompt\": \"a cat\"\n}\n```\n\n> 开始绘制.......[0%](https://filesystem.site/cdn/20240307/Pb4nCeoqGuKI969h6NZZUNOzXpGnrp.webp).[31%](https://filesystem.site/cdn/20240307/JGv6A4e8iaEB58TznyutorX4fClP9m.webp).[46%](https://filesystem.site/cdn/20240307/lup9Ceh1WUtk3qWqtBKo8UcZ8IfFv5.webp).[100%](https://filesystem.site/cdn/20240307/V2kb6sxI6RfQTlMWlKizLXs3L1p162.png)\n\n![a cat](https://filesystem.site/cdn/20240307/V2kb6sxI6RfQTlMWlKizLXs3L1p162.png)\n[⏬下载](https://filesystem.site/cdn/download/20240307/V2kb6sxI6RfQTlMWlKizLXs3L1p162.png)\n\n> message_id: `1215205657389572116`\n\n > channel_id: `1214825922717421570`\n\n > This message contains such action components \n\n|name|label|type|custom_id|\n|---|---|---|---|\n|放大第一张|U1|2|MJ::JOB::upsample::1::42968c9f-741a-456e-83e2-7a3ae6ae556e|\n|放大第二张|U2|2|MJ::JOB::upsample::2::42968c9f-741a-456e-83e2-7a3ae6ae556e|\n|放大第三张|U3|2|MJ::JOB::upsample::3::42968c9f-741a-456e-83e2-7a3ae6ae556e|\n|放大第四张|U4|2|MJ::JOB::upsample::4::42968c9f-741a-456e-83e2-7a3ae6ae556e|\n|重新生成|🔄|2|MJ::JOB::reroll::0::42968c9f-741a-456e-83e2-7a3ae6ae556e::SOLO|\n|第一张变体|V1|2|MJ::JOB::variation::1::42968c9f-741a-456e-83e2-7a3ae6ae556e|\n|第二张变体|V2|2|MJ::JOB::variation::2::42968c9f-741a-456e-83e2-7a3ae6ae556e|\n|第三张变体|V3|2|MJ::JOB::variation::3::42968c9f-741a-456e-83e2-7a3ae6ae556e|\n|第四张变体|V4|2|MJ::JOB::variation::4::42968c9f-741a-456e-83e2-7a3ae6ae556e|\n\n **接下来你可以直接对我说命令，例如：帮我放大第一张图**",
        },
        {
            "role":"user",
            "content":"放大第一张",
        }
    ],
}

response = requests.post(url, headers=headers, data=json.dumps(data))
print(response.text)