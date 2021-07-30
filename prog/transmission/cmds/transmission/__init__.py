"""
A package which provides a transmission client interface and a rudimentary
multi-attempt requests wrapper.
"""

from .transmission import Transmission, TransmissionTorrentStatus, CONFIG_DIR, CONFIG_FILE
from .utils import retry, StatusException
