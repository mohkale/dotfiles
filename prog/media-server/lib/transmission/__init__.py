"""
A package which provides a transmission client interface and a rudimentary
multi-attempt requests wrapper.
"""

from ._transmission_base import CONFIG_DIR, CONFIG_FILE
from ._utils import StatusException, retry
from .async_transmission import AsyncTransmission
from .enums import TransmissionTorrentStatus
from .transmission import Transmission
