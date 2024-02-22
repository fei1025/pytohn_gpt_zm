from typing import Any, Dict, Optional

from langchain_core.pydantic_v1 import BaseModel, Extra, root_validator
from langchain_core.utils import get_from_dict_or_env
import requests

class MyWolframAlphaAPIWrapper(BaseModel):
    wolfram_client: Any  #: :meta private:
    wolfram_alpha_appid: Optional[str] = None

    @root_validator()
    def validate_environment(cls, values: Dict) -> Dict:
        """Validate that api key and python package exists in environment."""
        wolfram_alpha_appid = get_from_dict_or_env(
            values, "wolfram_alpha_appid", "WOLFRAM_ALPHA_APPID"
        )
        values["wolfram_alpha_appid"] = wolfram_alpha_appid

        return values
    def query_wolfram_alpha(self,input_text ):
        app_id=self.wolfram_alpha_appid
        url = f"https://www.wolframalpha.com/api/v1/llm-api?input={input_text}&appid={app_id}"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print("Error:", response.status_code)

    def run(self, query: str) -> str:
        """Run query through WolframAlpha and parse result."""
        try:
            res = self.query_wolfram_alpha(query)
            return res
        except Exception as e:
            print(e)
            return "Wolfram Alpha wasn't able to answer it"

