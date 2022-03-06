"""Status misc segment for showing MullvadVPN connection status."""

import re
import subprocess
from distutils.spawn import find_executable as which

from .base import StatusMiscSegment


class MullvadVPNSegment(StatusMiscSegment):
    """Status line segment showing MullvadVPN status."""

    name = "mullvad-vpn"

    @classmethod
    def parser_args(cls, parser):
        mvpn = parser.add_argument_group("Mullvad VPN")
        mvpn.add_argument(
            f"--{cls.name}-icon",
            default="N",
            metavar="ICON",
            help="Icon shown to indicate mullvad-vpn status.",
        )
        mvpn.add_argument(
            f"--{cls.name}-hide",
            action="store_true",
            help="Hide mullvad-vpn status when disconnected",
        )
        mvpn.add_argument(
            f"--{cls.name}-active-style",
            default="",
            metavar="STYLE",
            help="Styling for an active mullvad-vpn connection.",
        )
        mvpn.add_argument(
            f"--{cls.name}-inactive-style",
            default="",
            metavar="STYLE",
            help="Styling for an inactive mullvad-vpn connection.",
        )

    def render(self):
        """MullvadVPN status-line section."""
        # pylint: disable=no-member
        if not which("mullvad"):
            return None
        proc = subprocess.run(
            ["mullvad", "status"], capture_output=True, encoding="utf-8"
        )
        if proc.returncode != 0:
            return None
        ip_address = ""
        match = re.search(
            r"Connected to (?:OpenVPN|WireGuard) (.+):(\d+) over UDP",
            proc.stdout,
            flags=re.IGNORECASE,
        )
        if not match:
            if self.hide:
                return None
        elif match:
            ip_address = " " + match[1]
        return (
            self._style(
                self.icon, self.active_style if ip_address else self.inactive_style
            )
            + ip_address
        )
