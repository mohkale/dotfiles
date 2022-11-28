"""
Client implementation for the transmission daemon.
"""

import asyncio
import enum
import json
import logging
import os
import pathlib as p
import socket

import aiohttp
from requests import Session

XDG_HOME = p.Path(os.environ.get("XDG_CONFIG_HOME", "~/.config")).expanduser()
CONFIG_DIR = XDG_HOME / "transmission-daemon"
CONFIG_FILE = CONFIG_DIR / "settings.json"


class TransmissionTorrentStatus(enum.IntEnum):
    """
    Possible values for the status field in the torrent-get request.

    See the [[https://github.com/transmission/transmission/blob/master/libtransmission/transmission.h#L1652][tr_torrent_activity]] enumeration in the transmission src.
    """

    stopped = 0
    check_wait = 1
    check = 2
    download_wait = 3
    download = 4
    seed_wait = 5
    seed = 6


class _TransmissionBase:
    def __init__(
        self, host: str = "localhost", port: int = 9091, path: str = "/transmission/rpc"
    ):
        self.host = host
        self.port = port
        self.path = path

    @classmethod
    def from_conf(cls, conf: object):
        """Create a Transmission instance from a transmission-daemon JSON config file."""
        return cls(
            conf.get("rpc-bind-address", "localhost"),
            conf.get("rpc-port", 9091),
            conf.get("rpc-url", "/transmission/") + "rpc",
        )

    @classmethod
    def from_conf_file(cls, conf: p.Path = CONFIG_FILE):
        """Alis for `self.from_conf` which automatically opens and reads `conf`."""
        return cls.from_conf(json.loads(conf.open().read()))

    @property
    def link(self):
        """URL like link for the transmission host"""
        link = "http://" + self.url
        if self.path:
            link = link + self.path
        return link

    @property
    def url(self):
        "host name portion of the transmission link"
        return self.host + ":" + str(self.port)


class Transmission(_TransmissionBase):
    """Simple interface to the transmission RPC API"""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.session = Session()

    def check(self):
        """
        Assert whether the current transmission daemon is running.
        """
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            try:
                s.connect((self.host, self.port))
                return True
            except socket.error:
                return False

    def _make_request(self, url, data):
        logging.debug("making request to method with body: %s", data)

        response = self.session.post(url, data=data)

        # users session id has expired
        if response.status_code == 409:
            session_id = response.headers["X-Transmission-Session-Id"]
            logging.info(
                "session responded with 409, updating session id to: %s", session_id
            )
            self.session.headers.update({"X-Transmission-Session-Id": session_id})

            # try again, with updated session id
            response = self._make_request(url, data)

        return response

    def command(self, method: str, **args):
        """Make a request to the tranmission API.

        Parameters
        ----------
        method
            the API method to call, see [[https://raw.githubusercontent.com/transmission/transmission/2.9x/extras/rpc-spec.txt][here]]
        args
            body of the arguments for section of the request
        """
        resp = self._make_request(
            self.link, json.dumps({"method": method, "arguments": {**args}})
        )

        resp_json = resp.json()
        if resp_json["result"] != "success":
            logging.error("request failed with status='%s'", resp_json["result"])
        resp.raise_for_status()
        return resp_json


class AsyncTransmission(_TransmissionBase):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._session = None

    async def __aenter__(self):
        self._session = aiohttp.ClientSession()
        return self

    async def __aexit__(self, *err):
        await self._session.close()
        self._session = None

    async def acheck(self) -> bool:
        """
        Assert whether the current transmission daemon is running
        asynchronously.
        """
        logging.debug(
            "Checking if Transmission daemon is alive at host=%s port=%d",
            self.host,
            self.port,
        )
        reader = writer = None
        try:
            reader, writer = await asyncio.open_connection(self.host, self.port)
            return True
        except OSError:
            return False
        finally:
            if writer is not None:
                writer.close()
                await writer.wait_closed()

    async def _make_request(self, url, data):
        logging.debug("Making request to method with body='%s'", data)
        async with self._session.post(url, data=data) as response:
            if response.status == 409:
                session_id = response.headers["X-Transmission-Session-Id"]
                logging.info(
                    "Session responded with code=409, updating session-id=%s",
                    session_id,
                )
                self._session.headers.update({"X-Transmission-Session-Id": session_id})

                # Try again, with updated session id
                return await self._make_request(url, data)

            response_json = await response.json()
            if response_json["result"] != "success":
                logging.error("Request failed with status=%s", response_json["result"])
            response.raise_for_status()
            return response_json

    async def acommand(self, method: str, **args):
        """Make a request to the tranmission API.

        Parameters
        ----------
        method
            the API method to call, see [[https://raw.githubusercontent.com/transmission/transmission/2.9x/extras/rpc-spec.txt][here]]
        args
            body of the arguments for section of the request
        """
        return await self._make_request(
            self.link, json.dumps({"method": method, "arguments": {**args}})
        )
