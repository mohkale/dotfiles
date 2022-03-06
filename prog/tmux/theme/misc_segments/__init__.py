"""Miscellaneous segments for my tmux status-line."""

from .base import StatusMiscSegment

from .mpd          import MPDSegment
from .github       import GithubNotificationsSegment
from .nordvpn      import NordVPNSegment
from .mullvad_vpn  import MullvadVPNSegment
from .notmuch      import NotMuchSegment
from .transmission import TransmissionNotificationSegment
from .battery_life import BatteryLifeSegment
