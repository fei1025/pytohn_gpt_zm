from math import ceil

def count_image_tokens(width: int, height: int):
    h = ceil(height / 512)
    w = ceil(width / 512)
    n = w * h
    total = 85 + 170 * n
    return total

import math

def calculate_image_tokens(w, y, low=False):
    v = 85
    x = 170
    C = 1e-5

    o = int(w)
    s = int(y)
    u = low

    r = 9 * o > 2048 or s > 2048
    if r:
        if o > s:
            r = 2048
        else:
            r = round(2048 * (o / s))
    else:
        r = o

    d = o > 2048 or s > 2048
    if d:
        if o > s:
            d = round(2048 / (o / s))
        else:
            d = 2048
    else:
        d = s

    I = r > 768 or d > 768
    if I:
        if r < d:
            I = min(768, r)
        else:
            I = round(min(768, d) * (r / d))
    else:
        I = r

    R = r > 768 or d > 768
    if R:
        if r < d:
            R = round(min(768, r) / (r / d))
        else:
            R = min(768, d)
    else:
        R = d

    z = 1 + math.ceil((R - 512) / (512 * (1 - 0)))
    k = 1 + math.ceil((I - 512) / (512 * (1 - 0)))
    P = z * k

    if u:
        M = v
    else:
        M = v + P * x

    H = M * C

    return {
        'initialResizeWidth': r,
        'initialResizeHeight': d,
        'furtherResizeWidth': I,
        'furtherResizeHeight': R,
        'verticalTiles': z,
        'horizontalTiles': k,
        'totalTiles': P,
        'totalTokens': M,
        'totalPrice': format(H, '.5f')
    }

"""
{
    'initialResizeWidth': 2048,  # 初始调整后的宽度
    'initialResizeHeight': 800,   # 初始调整后的高度
    'furtherResizeWidth': 1966,   # 进一步调整后的宽度
    'furtherResizeHeight': 768,   # 进一步调整后的高度
    'verticalTiles': 2,           # 垂直方向的瓦片数量
    'horizontalTiles': 4,         # 水平方向的瓦片数量
    'totalTiles': 8,               # 总瓦片数量
    'totalTokens': 1445,          # 总令牌数量
    'totalPrice': '0.01445'       # 总价格
}
"""
# 示例用法
# totalTokens 这是token
if __name__ == "__main__":
    result = calculate_image_tokens(7680, 4320)
    print(result)
    result = count_image_tokens(7680,4320)
    print(result)
