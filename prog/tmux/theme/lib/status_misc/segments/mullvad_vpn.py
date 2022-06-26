"""Status misc segment for showing MullvadVPN connection status."""
# pylint: disable=no-member

import logging
import re
import subprocess
from distutils.spawn import find_executable as which

from ..segment import StatusMiscSegment


class MullvadVPNSegment(StatusMiscSegment):
    """Status line segment showing MullvadVPN status."""

    name = "mullvad-vpn"

    @classmethod
    def parser_args(cls, parser):
        mvpn_group = parser.add_argument_group("Mullvad VPN")
        super().parser_args(mvpn_group)

        mvpn_group.add_argument(
            f"--{cls.name}-icon",
            default="N",
            metavar="ICON",
            help="Icon shown to indicate mullvad-vpn status.",
        )
        mvpn_group.add_argument(
            f"--{cls.name}-hide",
            action="store_true",
            help="Hide mullvad-vpn status when disconnected",
        )
        mvpn_group.add_argument(
            f"--{cls.name}-active-style",
            default="",
            metavar="STYLE",
            help="Styling for an active mullvad-vpn connection.",
        )
        mvpn_group.add_argument(
            f"--{cls.name}-inactive-style",
            default="",
            metavar="STYLE",
            help="Styling for an inactive mullvad-vpn connection.",
        )

    def render(self):
        """MullvadVPN status-line section."""
        if not which("mullvad"):
            logging.debug(
                "Skipping segment=%s because mullvad is not installed.", self.name
            )
            return None
        proc = subprocess.run(
            ["mullvad", "status", "--location"], capture_output=True, encoding="utf-8"
        )
        if proc.returncode != 0:
            logging.warning(
                "Warning failed to run mullvad process for segment=%s", self.name
            )
            return None
        ip_address = ""
        match = re.search(
            r'Connected to (?:.*\n)IPv4: (.+)$',
            proc.stdout,
            flags=re.IGNORECASE|re.MULTILINE,
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
