wolfrmpo="""
API documentation:
Endpoint: https://www.wolframalpha.com/api
GET /v1/llm-api

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