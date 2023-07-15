import logging
import pathlib
from types import TracebackType
from typing import Any, Dict, Optional, Type

from mohkale import transmission as t

from ._base import TorrentClient


class TransmissionDaemonClient(TorrentClient):
    def __init__(self, config_file: pathlib.Path):
        self._client = t.AsyncTransmission.from_conf_file(config_file)

    async def __aenter__(self) -> "TransmissionDaemonClient":
        await self._client.__aenter__()
        return self

    async def __aexit__(
        self,
        exc_type: Optional[Type[BaseException]],
        exc_val: Optional[BaseException],
        exc_tb: Optional[TracebackType],
    ) -> None:
        await self._client.__aexit__(exc_type, exc_val, exc_tb)

    async def is_alive(self) -> bool:
        return await self._client.acheck()

    async def add_torrent(
        self,
        file: pathlib.Path,
        translated_file: pathlib.Path,
        overrides: Dict[str, Any],
    ) -> Optional[str]:
        return await self._add(str(translated_file), overrides)

    async def add_magnetlink(
        self, magnetlink: str, overrides: Dict[str, Any]
    ) -> Optional[str]:
        return await self._add(magnetlink, overrides)

    async def _add(self, url: str, overrides: Dict[str, Any]) -> Optional[str]:
        try:
            return await self._add2(url, overrides)
        except t.StatusException:
            logging.exception('Failed to add torrent="%s"', url)
            return None

    @t.retry(5)
    async def _add2(self, url: str, overrides: Dict[str, Any]) -> str:
        logging.info("Adding torrent='%s' with overrides=%s", url, overrides)
        resp = await self._client.acommand(
            "torrent-add",
            filename=url,
            **overrides,
        )
        if resp["result"] != "success":
            raise t.StatusException("Encountered non-sucess status")
        resp_args = resp["arguments"]
        key = (
            "torrent-duplicate" if "torrent-duplicate" in resp_args else "torrent-added"
        )
        return resp_args[key]["hashString"]

    async def move(self, torrent_id: Any, dest: str) -> bool:
        try:
            return await self._move2(torrent_id, dest)
        except t.StatusException:
            logging.exception(
                'Failed to move torrent="%s" to dest="%s"', torrent_id, dest
            )
            return False

    @t.retry(5)
    async def _move2(self, torrent_id: Any, dest: str) -> bool:
        resp = await self._client.acommand(
            "torrent-set-location", ids=torrent_id, move=True, location=dest
        )
        if resp["result"] != "success":
            raise t.StatusException("Encountered non-sucess status")
        return True
