from typing import Any, Dict, Optional

from langchain.chains import APIChain
from langchain_core.callbacks import CallbackManagerForToolRun
from langchain_core.language_models import BaseLanguageModel
from langchain_core.pydantic_v1 import BaseModel, Extra, root_validator
from langchain_core.tools import BaseTool
from langchain_core.utils import get_from_dict_or_env
import requests

wolfrmpo="""
- WolframAlpha understands natural language queries about entities in chemistry, physics, geography, history, art, astronomy, and more.
- WolframAlpha performs mathematical calculations, date and unit conversions, formula solving, etc.
- Convert inputs to simplified keyword queries whenever possible (e.g. convert "how many people live in France" to "France population").
- Send queries in English only; translate non-English queries before sending, then respond in the original language.
- Display image URLs with Markdown syntax: ![URL]
- ALWAYS use this exponent notation: `6*10^14`, NEVER `6e14`.
- ALWAYS use {"input": query} structure for queries to Wolfram endpoints; `query` must ONLY be a single-line string.
- ALWAYS use proper Markdown formatting for all math, scientific, and chemical formulas, symbols, etc.:  '$$\n[expression]\n$$' for standalone cases and '\( [expression] \)' when inline.
- Never mention your knowledge cutoff date; Wolfram may return more recent data.
- Use ONLY single-letter variable names, with or without integer subscript (e.g., n, n1, n_1).
- Use named physical constants (e.g., 'speed of light') without numerical substitution.
- Include a space between compound units (e.g., "Ω m" for "ohm*meter").
- To solve for a variable in an equation with units, consider solving a corresponding equation without units; exclude counting units (e.g., books), include genuine units (e.g., kg).
- If data for multiple properties is needed, make separate calls for each property.
- If a WolframAlpha result is not relevant to the query:
 -- If Wolfram provides multiple 'Assumptions' for a query, choose the more relevant one(s) without explaining the initial result. If you are unsure, ask the user to choose.
 -- Re-send the exact same 'input' with NO modifications, and add the 'assumption' parameter, formatted as a list, with the relevant values.
 -- ONLY simplify or rephrase the initial query if a more relevant 'Assumption' or other input suggestions are not provided.
 -- Do not explain each step unless user input is needed. Proceed directly to making a better API call based on the available assumptions.
"""
class MyWolframAlphaAPIWrapper(BaseModel):
    llm: Optional[BaseLanguageModel] = None
    wolfram_alpha_appid: Optional[str] = None


    def query_wolfram_alpha(self,input_text ):
        app_id=self.wolfram_alpha_appid
        url = f"https://www.wolframalpha.com/api/v1/llm-api?input={input_text}&appid={app_id}"
        response = requests.get(url)
        if response.status_code == 200:
            return response.text
        else:
            print("Error:", response.status_code)
            return f"请求出现异常{response.status_code}"

    def run(self, query: str) -> str:
        # chain = APIChain.from_llm_and_api_docs(
        #     self.llm,
        #     wolfrmpo,
        #     headers={"X-Api-Key": self.wolfram_alpha_appid},
        #     limit_to_domains=None,
        # )

        """Run query through WolframAlpha and parse result."""
        try:
            res = self.query_wolfram_alpha(query)
            return res
        except Exception as e:
            print(e)
            return "Wolfram Alpha wasn't able to answer it"

class MyWolframAlphaQueryRun(BaseTool):
    """Tool that queries using the Wolfram Alpha SDK."""

    name: str = "wolfram_alpha"
    description: str = (
        "A wrapper around Wolfram Alpha. "
        "Useful for when you need to answer questions about Math, "
        "Science, Technology, Culture, Society and Everyday Life. "
        "Input should be a search query."
        " Send queries in English only; translate non-English queries before sending, then respond in the original language."
        "If there is a picture, use Markdown format to display the picture"
    )
    api_wrapper: MyWolframAlphaAPIWrapper

    def _run(
        self,
        query: str,
        run_manager: Optional[CallbackManagerForToolRun] = None,
    ) -> str:
        """Use the WolframAlpha tool."""
        return self.api_wrapper.run(query)

