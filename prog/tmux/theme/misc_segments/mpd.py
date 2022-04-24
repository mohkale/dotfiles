"""Status misc segment for MPD status."""

import logging

from .base import StatusMiscSegment


class MPDSegment(StatusMiscSegment):
    name = "mpd"

    @classmethod
    def parser_args(cls, parser):
        mpd_group = parser.add_argument_group("Music Player Daemon")
        mpd_group.add_argument(
            f"--{cls.name}-icon",
            default="M",
            metavar="ICON",
            help="Icon shown to indicate MPD status.",
        )
        mpd_group.add_argument(
            f"--{cls.name}-playing-style",
            metavar="STYLE",
            default="",
            help="Styling for when MPD is playing something.",
        )
        mpd_group.add_argument(
            f"--{cls.name}-paused-style",
            metavar="STYLE",
            default="",
            help="Styling for when MPD is paused.",
        )
        mpd_group.add_argument(
            f"--{cls.name}-hide-when-zero",
            action="store_true",
            help="Don't show any playlist size if the playlist is empty.",
        )

    _client = None

    def _status(self):
        # We always need to have mpd imported, so we can catch errors.
        try:
            import mpd
        except ImportError:
            logging.warning("Failed to import mpd")
            return None

        # Reuse existing client from previous connection if possible.
        if self._client is not None:
            try:
                return self._client.status()
            except mpd.ConnectionError:
                logging.warning("Client connection interrupted, deleting")
                self._client.disconnect()
                self._client = None

        # Create a new client and return the current mpd session.
        self._client = mpd.MPDClient()
        self._client.timeout = 10
        self._client.idletimeout = None
        try:
            self._client.connect("localhost", 6600)
            return self._client.status()
        except (mpd.ConnectionError, ConnectionRefusedError):
            self._client.disconnect()
            self._client = None
        return None

    def render(self):
        status = self._status()
        if not status:
            return

        position = int(status["song"])
        size = int(status["playlistlength"])
        playing = status["state"] == "play"

        res = ""
        res += self._style(
            self.icon, self.playing_style if playing else self.paused_style
        )
        if size != 0 or not self.hide_when_zero:
            res += f" {position+1:02d}/{size:02d}"

        return res
