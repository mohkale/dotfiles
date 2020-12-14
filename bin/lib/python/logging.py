#!/usr/bin/env python3
import io
import sys
import logging

def zerolog(level, *, fd=sys.stderr, color=True):
    """Setup a prettier, [[https://github.com/rs/zerolog][zerolog]] like logger.
    """
    black    = "\x1b[30m"
    red      = "\x1b[31m"
    green    = "\x1b[32m"
    yellow   = "\x1b[33m"
    # blue     = "\x1b[34m"
    # magenta  = "\x1b[35m"
    # cyan     = "\x1b[36m"
    # white    = "\x1b[37m"
    bold_red = "\x1b[31;1m"
    reset    = "\x1b[0m"

    log_format = (black if color else '') + "%(asctime)s " + (reset if color else '') + "%(levelname)s %(message)s"

    logging.addLevelName(logging.DEBUG,    (yellow   if color else '') + 'DBG' + (reset if color else ''))
    logging.addLevelName(logging.INFO,     (green    if color else '') + 'INF' + (reset if color else ''))
    logging.addLevelName(logging.WARNING,  (yellow   if color else '') + 'WRN' + (reset if color else ''))
    logging.addLevelName(logging.ERROR,    (red      if color else '') + 'ERR' + (reset if color else ''))
    logging.addLevelName(logging.CRITICAL, (bold_red if color else '') + 'CRT' + (reset if color else ''))

    logging_args = {
        'level': level,
        'format': log_format,
        'datefmt': '%H:%M%p',
    }
    if isinstance(fd, io.TextIOWrapper):
        logging_args['stream'] = fd
    else:
        logging_args['handlers'] = [logging.FileHandler(fd, 'a', 'utf-8')]

    logging.basicConfig(**logging_args)
