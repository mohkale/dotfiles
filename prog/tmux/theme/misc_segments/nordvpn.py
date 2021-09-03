"""Status misc segment for showing NordVPN connection status."""

import re
import subprocess
from distutils.spawn import find_executable as which

from .base import StatusMiscSegment

class NordVPNSegment(StatusMiscSegment):
    """Status line segment showing NordVPN status."""

    name = 'nordvpn'

    @classmethod
    def parser_args(cls, parser):
        nvpn = parser.add_argument_group('Nord VPN')
        nvpn.add_argument(f'--{cls.name}-icon', default='N', metavar='ICON',
                          help='Icon shown to indicate nordvpn status.')
        nvpn.add_argument(f'--{cls.name}-hide',
                          action='store_true',
                          help='Hide nordvpn status when disconnected')
        nvpn.add_argument(f'--{cls.name}-active-style',
                          default='', metavar='STYLE',
                          help='Styling for an active nordvpn connection.')
        nvpn.add_argument(f'--{cls.name}-inactive-style',
                          default='', metavar='STYLE',
                          help='Styling for an inactive nordvpn connection.')

    def render(self):
        """Nordvpn status-line section."""
        # pylint: disable=no-member
        if not which('nordvpn'):
            return None
        proc = subprocess.run(['nordvpn', 'status'], capture_output=True, encoding='utf-8')
        if proc.returncode != 0:
            return None
        ip_address = ''
        match = re.search(r'Server IP: (.+)', proc.stdout, flags=re.IGNORECASE)
        if not match:
            if self.nordvpn_hide:
                return None
        elif match:
            ip_address = ' ' + match[1]
        return self._style(self.icon,
                           self.active_style if ip_address else self.inactive_style) + ip_address
