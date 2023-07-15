"""Base for Transmission client."""

import json
import os
import pathlib
from typing import Dict, Any

CONFIG_DIR = pathlib.Path(
    os.environ.get(
        "TRANSMISSION_HOME",
        os.path.join(
            os.environ.get("XDG_CONFIG_HOME", "~/.config"),
            "media-server",
            "transmission",
        ),
    )
)
CONFIG_FILE = CONFIG_DIR / "settings.json"


class _TransmissionBase:
    def __init__(
        self,
        host: str = "localhost",
        port: int = 9091,
        path: str = "/transmission/rpc",
    ):
        self.host = host
        self.port = port
        self.path = path

    @classmethod
    def from_conf(cls, conf: Dict[str, Any]):
        """Create a Transmission instance from a transmission-daemon JSON config file."""
        return cls(
            conf.get("rpc-bind-address", "localhost"),
            conf.get("rpc-port", 9091),
            conf.get("rpc-url", "/transmission/") + "rpc",
        )

    @classmethod
    def from_conf_file(cls, conf: pathlib.Path = CONFIG_FILE):
        """Alias for `self.from_conf` which automatically opens and reads `conf`."""
        return cls.from_conf(json.loads(conf.open().read()))

    @property
    def link(self):
        """URL like link for the transmission host."""
        link = "http://" + self.url
        if self.path:
            link = link + self.path
        return link

    @property
    def url(self):
        """Host name portion of the transmission link."""
        return self.host + ":" + str(self.port)
