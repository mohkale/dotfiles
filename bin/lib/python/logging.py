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
    if hasattr(logging, 'TRACE'):
        logging.addLevelName(logging.TRACE, (black if color else '') + 'TRC' + (reset if color else ''))

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

def add_logging_level(level_name, level_num, method_name=None):
    """
    Comprehensively add a new logging level to the `logging` module and the currently configured logging class.

    Taken from [[https://stackoverflow.com/a/35804945][here]].

    `level_name` becomes an attribute of the `logging` module with the value
    `level_num`. `method_name` becomes a convenience method for both `logging`
    itself and the class returned by `logging.getLoggerClass()` (usually just
    `logging.Logger`). If `method_name` is not specified, `level_name.lower()` is
    used.

    To avoid accidental clobberings of existing attributes, this method will
    raise an `AttributeError` if the level name is already an attribute of the
    `logging` module or if the method name is already present.

    Example
    -------
    >>> addLoggingLevel('TRACE', logging.DEBUG - 5)
    >>> logging.getLogger(__name__).setLevel("TRACE")
    >>> logging.getLogger(__name__).trace('that worked')
    >>> logging.trace('so did this')
    >>> logging.TRACE
    5

    """
    if not method_name:
        method_name = level_name.lower()

    if hasattr(logging, level_name):
        raise AttributeError('{} already defined in logging module'.format(level_name))

    if hasattr(logging, method_name):
        raise AttributeError('{} already defined in logging module'.format(method_name))

    if hasattr(logging.getLoggerClass(), method_name):
        raise AttributeError('{} already defined in logger class'.format(method_name))

    # This method was inspired by the answers to Stack Overflow post
    # http://stackoverflow.com/q/2183233/2988730, especially
    # http://stackoverflow.com/a/13638084/2988730
    def logForLevel(self, message, *args, **kwargs):
        if self.isEnabledFor(level_num):
            self._log(level_num, message, args, **kwargs)

    def logToRoot(message, *args, **kwargs):
        logging.log(level_num, message, *args, **kwargs)

    logging.addLevelName(level_num, level_name)
    setattr(logging, level_name, level_num)
    setattr(logging.getLoggerClass(), method_name, logForLevel)
    setattr(logging, method_name, logToRoot)
