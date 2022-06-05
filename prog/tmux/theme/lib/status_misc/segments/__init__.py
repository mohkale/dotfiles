"""All misc-status segments."""
from .battery_life import BatteryLifeSegment
from .docker import DockerSegment
from .github import GithubNotificationsSegment
from .mpd import MPDSegment
from .mullvad_vpn import MullvadVPNSegment
from .nordvpn import NordVPNSegment
from .notmuch import NotMuchSegment
from .transmission import TransmissionNotificationSegment

__all__ = [
    "MPDSegment",
    "GithubNotificationsSegment",
    "NordVPNSegment",
    "MullvadVPNSegment",
    "NotMuchSegment",
    "TransmissionNotificationSegment",
    "BatteryLifeSegment",
    "DockerSegment",
]
