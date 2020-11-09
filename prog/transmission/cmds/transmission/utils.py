import time
import logging
import requests
import functools

class StatusException(Exception):
    pass

def retry(times):
    def decorator(func):
        @functools.wraps(func)
        def wrapped(*args, **kwargs):
            for i in range(times-1):
                try:
                    return func(*args, **kwargs)
                except (requests.HTTPError,StatusException) as e:
                    logging.warn('request raised HTTPError, trying again')
                    time.sleep(3)
            return func(*args, **kwargs)
        return wrapped
    return decorator

