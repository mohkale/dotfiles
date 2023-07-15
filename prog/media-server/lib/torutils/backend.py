import enum
import os
import pathlib

from . import clients


class TorrentBackend(enum.IntEnum):
    TRANSMISSION = enum.auto()
    QBITTORRENT = enum.auto()

    @classmethod
    def default(cls) -> "TorrentBackend":
        return cls.TRANSMISSION

    @property
    def title(self):
        if self == TorrentBackend.TRANSMISSION:
            return "Transmission"
        if self == TorrentBackend.QBITTORRENT:
            return "qBittorrent"
        return "Unknown"

    def config_dir(self) -> pathlib.Path:
        return pathlib.Path(
            os.environ.get(
                self.name + "_HOME",
                os.path.join(
                    os.environ.get("XDG_CONFIG_HOME", "~/.config"),
                    "media-server",
                    self._config_dir_basename(),
                ),
            )
        )

    def _config_dir_basename(self) -> str:
        if self == TorrentBackend.TRANSMISSION:
            return "transmission"
        if self == TorrentBackend.QBITTORRENT:
            return "qbittorrent"
        raise ValueError(f"Unknown torrent-backend={self}")

    def client(self):
        if self == TorrentBackend.TRANSMISSION:
            return clients.TransmissionDaemonClient(self.config_dir() / "settings.json")
        if self == TorrentBackend.QBITTORRENT:
            return clients.QBittorrentDaemonClient(self.config_dir() / "client-settings.json")
        raise ValueError(f"torrent-backend={self} has no supported client")
