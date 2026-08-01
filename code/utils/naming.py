import re

def split_camel_case(text: str) -> list:
    """
    Split CamelCase string into a list of words.
    """
    text = re.sub('(.)([A-Z][a-z]+)', r'\1 \2', text)
    text = re.sub('([a-z0-9])([A-Z])', r'\1 \2', text)
    return text.split()
