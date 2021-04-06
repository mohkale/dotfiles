"""
Access your current terminals teletype device.
"""
import os
import io
import sys
import logging

def open_tty() -> io.FileIO:
    """Open your current terminals tty and return it as a file descriptor.
    """
    try:
        tty = os.ttyname(2)
    except: tty = '/dev/tty'

    try:
        return io.TextIOWrapper(io.FileIO(os.open(tty, os.O_NOCTTY | os.O_RDWR), "r+"))
    except:
        logging.fatal('Failed to open tty: %s', tty)
        sys.exit(1)
