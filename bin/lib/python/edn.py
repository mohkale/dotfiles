"""
Helpers for a lispy data serialisation format.
"""
import edn_format

keyword_name = lambda keyword: \
    keyword.name.split("/", 1)[1] if "/" in keyword.name else keyword.name
strinfigy_keyword = lambda x: \
    keyword_name(x) if isinstance(x, edn_format.Keyword) else x

# Taken from [[https://github.com/swaroopch/edn_format/issues/76#issuecomment-665328577][here]].
def process_edn(x):
    """
    Convert edn symbols in parsed objects to strings.
    """
    if isinstance(x, edn_format.ImmutableDict):
        return {strinfigy_keyword(k): process_edn(v) for k, v in x.items()}
    elif isinstance(x, edn_format.ImmutableList) or isinstance(x, tuple):
        return [process_edn(v) for v in x]
    else:
        return strinfigy_keyword(x)
