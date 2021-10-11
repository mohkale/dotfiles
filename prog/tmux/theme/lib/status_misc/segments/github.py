"""Status misc segment for showing github notifications."""
# pylint: disable=no-member

import logging
import os
import pathlib

import requests.exceptions

from ..segment import StatusMiscSegment


class GithubNotificationsSegment(StatusMiscSegment):
    """Status line segment showing number of github notifications."""

    name = "github"

    @classmethod
    def parser_args(cls, parser):
        github_group = parser.add_argument_group("Github Notifications")
        super().parser_args(github_group)

        github_group.add_argument(
            f"--{cls.name}-format",
            default="{:02d}",
            help="Format string for github notification counts.",
        )
        github_group.add_argument(
            f"--{cls.name}-icon",
            default="G",
            metavar="ICON",
            help="Icon shown to indicate github status.",
        )
        github_group.add_argument(
            f"--{cls.name}-icon-style",
            default="",
            metavar="STYLE",
            help="Styling for github icon",
        )
        github_group.add_argument(
            f"--{cls.name}-hide-zero",
            action="store_true",
            help="When true don't show when no icons.",
        )
        github_group.add_argument(
            f"--{cls.name}-count-style",
            default="",
            metavar="STYLE",
            help="Styling for github notification count.",
        )
        github_group.add_argument(
            f"--{cls.name}-config",
            type=pathlib.Path,
            default=pathlib.Path(os.path.expandvars("$TMUX_HOME/github-api.key")),
            help="Specify mount map configuration file",
        )

    _client = None

    @property
    def client(self):
        """Github client."""
        if self._client is None:
            try:
                logging.debug("Trying to import github")
                # pip install pygithub
                # pylint: disable=import-outside-toplevel
                import github
                from github.MainClass import DEFAULT_BASE_URL
            except ImportError:
                logging.warning("Failed to import github")
                return None
            base_url, pass_key = self.pass_key
            if not pass_key:
                return None
            if not base_url:
                base_url = DEFAULT_BASE_URL
            self._client = github.Github(base_url=base_url, login_or_token=pass_key)
        return self._client

    @property
    def pass_key(self):
        """API Key for accessing github notifications.

        This should be saved to the file at `self.config`. The format
        can be either the entire key string or an optional base-url
        followed by a pipe symbol and then the access key.
        """
        # pylint: disable=no-member
        # TODO: Re-read when key files been modified
        if not self.config.exists():
            logging.warning(
                "Can't access key file=%s for segment=%s", self.config, self.name
            )
            return None

        with self.config.open("r") as f:
            contents = f.read().strip()
        base_url = None

        pos = contents.find("|")
        if pos != -1:
            base_url = contents[:pos]
            contents = contents[pos + 1 :]
        return base_url, contents

    def render(self):
        client = self.client
        if not client:
            return None
        try:
            count = client.get_user().get_notifications().totalCount
        except requests.exceptions.RequestException:
            return None
        if self.hide_zero and count == 0:
            return None
        return " ".join(
            x
            for x in [
                self._style(self.icon, self.icon_style),
                self._style(self.format.format(count), self.count_style),
            ]
            if x
        )