import re

key = lambda key: [int(chunk) if chunk.isdigit() else chunk.lower()
              for chunk in re.split('([0-9]+)', key.path)]

def natural_sort(it):
    """Sort and return it naturally.
    """
    return sorted(it, key=key)
