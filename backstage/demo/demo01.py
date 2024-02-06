from langchain_community.utilities.wolfram_alpha import WolframAlphaAPIWrapper

wolfram = WolframAlphaAPIWrapper(wolfram_alpha_appid="5V6ELP-UUPQLEAUXU")

print(wolfram.run("population %20 france"))