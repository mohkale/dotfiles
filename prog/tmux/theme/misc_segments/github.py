"""Status misc segment for showing github notifications."""

import os
import logging
import pathlib

import requests.exceptions

from .base import StatusMiscSegment

class GithubNotificationsSegment(StatusMiscSegment):
    """Status line segment showing number of github notifications."""

    name = 'github'

    @classmethod
    def parser_args(cls, parser):
        github_group = parser.add_argument_group('Github Notifications')
        github_group.add_argument(f'--{cls.name}-format',
                                  default='{:02d}',
                                  help='Format string for github notification counts.')
        github_group.add_argument(f'--{cls.name}-icon', default='G', metavar='ICON',
                                  help='Icon shown to indicate github status.')
        github_group.add_argument(f'--{cls.name}-icon-style',
                                  default='', metavar='STYLE',
                                  help='Styling for github icon')
        github_group.add_argument(f'--{cls.name}-hide-zero', action='store_true',
                                  help="When true don't show when no icons.")
        github_group.add_argument(f'--{cls.name}-count-style',
                                  default='', metavar='STYLE',
                                  help='Styling for github notification count.')
        github_group.add_argument(f'--{cls.name}-config', type=pathlib.Path,
                                  default=pathlib.Path(os.path.expandvars('$TMUX_HOME/github-api.key')),
                                  help='Specify mount map configuration file')

    _client = None

    @property
    def client(self):
        """Github client."""
        if not self._client:
            try:
                # pip install pygithub
                # pylint: disable=import-outside-toplevel
                import github
            except ImportError:
                logging.warning('Failed to import github')
                return None
            pass_key = self.api_pass
            if not pass_key:
                return None
            self._client = github.Github(pass_key)
        return self._client

    @property
    def api_pass(self):
        """API Key for accessing github notifications."""
        # pylint: disable=no-member
        # TODO: Re-read when key files been modified
        if not self.config.exists():
            logging.warning("Github status line section can't access key file: %s", self.config)
            return None
        with self.config.open('r') as f:
            return f.read().strip()

    def render(self):
        # pylint: disable=no-member
        client = self.client
        if not client:
            return None
        try:
            count = client.get_user().get_notifications().totalCount
        except requests.exceptions.RequestException:
            return None
        if self.hide_zero and count == 0:
            return None
        return ' '.join(x for x in [
            self._style(self.icon, self.icon_style),
            self._style(self.format.format(count), self.count_style),
        ] if x)
