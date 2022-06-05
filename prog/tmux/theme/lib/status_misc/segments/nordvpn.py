"""Status misc segment for showing NordVPN connection status."""
# pylint: disable=no-member

import logging
import re
import subprocess
from distutils.spawn import find_executable as which

from ..segment import StatusMiscSegment


class NordVPNSegment(StatusMiscSegment):
    """Status line segment showing NordVPN status."""

    name = "nordvpn"

    @classmethod
    def parser_args(cls, parser):
        nvpn_group = parser.add_argument_group("Nord VPN")
        super().parser_args(nvpn_group)

        nvpn_group.add_argument(
            f"--{cls.name}-icon",
            default="N",
            metavar="ICON",
            help="Icon shown to indicate nordvpn status.",
        )
        nvpn_group.add_argument(
            f"--{cls.name}-hide",
            action="store_true",
            help="Hide nordvpn status when disconnected",
        )
        nvpn_group.add_argument(
            f"--{cls.name}-active-style",
            default="",
            metavar="STYLE",
            help="Styling for an active nordvpn connection.",
        )
        nvpn_group.add_argument(
            f"--{cls.name}-inactive-style",
            default="",
            metavar="STYLE",
            help="Styling for an inactive nordvpn connection.",
        )

    def render(self):
        """Nordvpn status-line section."""
        # pylint: disable=no-member
        if not which("nordvpn"):
            logging.debug(
                "Skipping segment=%s because nordvpn is not installed.", self.name
            )
            return None
        proc = subprocess.run(
            ["nordvpn", "status"], check=False, capture_output=True, encoding="utf-8"
        )
        if proc.returncode != 0:
            logging.warning(
                "Warning failed to run nordvpn process for segment=%s", self.name
            )
            return None
        ip_address = ""
        match = re.search(r"Server IP: (.+)", proc.stdout, flags=re.IGNORECASE)
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
