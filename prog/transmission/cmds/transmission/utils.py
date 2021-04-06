"""
Utility methods for interacting with the transmission daemon.
"""

import functools
import logging
import time

import requests


class StatusException(Exception):
    """Transmission responded with a none-ok status.
    """
    pass

def retry(times):
    """Retry wrapped function upto `times` times.
    """
    def decorator(func):
        @functools.wraps(func)
        def wrapped(*args, **kwargs):
            for _ in range(times-1):
                try:
                    return func(*args, **kwargs)
                except (requests.HTTPError,StatusException):
                    logging.warning('request raised HTTPError, trying again')
                    time.sleep(3)
            return func(*args, **kwargs)
        return wrapped
    return decorator
