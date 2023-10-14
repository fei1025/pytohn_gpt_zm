cache = {}


def ca_save(key, value):
    cache[key] = value


def calculate_value(key):
    # 检查缓存中是否存在对应的结果
    if key in cache:
        return cache[key]
    else:
        return None


def remove_cal(key):
    if key in cache:
        cache.pop(key)
