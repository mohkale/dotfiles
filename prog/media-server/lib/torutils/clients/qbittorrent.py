import json
import logging
import pathlib
from types import TracebackType
from typing import Any, Dict, Optional, Type

import qbittorrentapi as qbit
import tenacity

from .. import portutils
from ._base import TorrentClient


class QBittorrentDaemonClient(TorrentClient):
    def __init__(self, config_file: pathlib.Path):
        with config_file.open("r", encoding="utf-8") as config_fd:
            config = json.loads(config_fd.read())

        self._client = qbit.Client(**config)
        self._host = config.get("host", "localhost")
        self._port = config.get("port", 8080)

    async def __aenter__(self) -> "QBittorrentDaemonClient":
        return self

    async def __aexit__(
        self,
        exc_type: Optional[Type[BaseException]],
        exc_val: Optional[BaseException],
        exc_tb: Optional[TracebackType],
    ) -> None:
        pass

    async def is_alive(self) -> bool:
        return await portutils.is_alive(self._host, self._port)

    async def move(self, torrent_id: Any, dest: str) -> bool:
        try:
            return await self._move2(torrent_id, dest)
        except tenacity.RetryError:
            logging.exception(
                'Failed to move torrent="%s" to dest="%s"', torrent_id, dest
            )
            return False

    @tenacity.retry(
        stop=tenacity.stop_after_attempt(5),
        wait=tenacity.wait_random(min=1, max=5),
        retry=(
            tenacity.retry_if_not_exception_type(qbit.Forbidden403Error)
            & tenacity.retry_if_not_exception_type(qbit.Conflict409Error)
        )
        | tenacity.retry_if_not_result(lambda res: res),
    )
    async def _move2(self, torrent_id: Any, dest: str) -> bool:
        self._client.torrents_set_location(dest, torrent_id)
        return True

    @staticmethod
    def _translate_overrides(overrides: Dict[str, Any]) -> Dict[str, Any]:
        new_overrides = {}

        paused = False
        paused = overrides.pop("paused", paused)
        new_overrides["is_paused"] = paused

        if "download-dir" in overrides:
            new_overrides["save_path"] = overrides.pop("download-dir")
            # Auto management bypasses the `save_path` option.
            new_overrides["use_auto_torrent_management"] = False

        if overrides.pop("bandwidthPriority", None):
            logging.warning(
                "qbittorrent does not support the bandwidth priority option"
            )

        if overrides:
            logging.warning(
                "Unsupported transmission overrides=%s for qbittorrent", overrides
            )

        logging.debug(
            "Overrode transmission args=%s with new-args=%s",
            repr(overrides),
            repr(new_overrides),
        )
        return new_overrides

    async def add_torrent(
        self,
        file: pathlib.Path,
        translated_file: pathlib.Path,
        overrides: Dict[str, Any],
    ) -> Optional[str]:
        overrides = self._translate_overrides(overrides)
        return self._add(torrent_files=str(file), **overrides)

    async def add_magnetlink(
        self, magnetlink: str, overrides: Dict[str, Any]
    ) -> Optional[str]:
        overrides = self._translate_overrides(overrides)
        return self._add(urls=magnetlink, **overrides)

    def _add(self, *args, **kwargs) -> Optional[str]:
        logging.debug("Adding torrent with args=%s kwargs=%s", repr(args), repr(kwargs))
        try:
            if self._add2(*args, **kwargs):
                return self._get_most_recently_added_torrent_hash()
        except tenacity.RetryError:
            logging.exception(
                "Failed to add torrent with args=%s kwargs=%s", repr(args), repr(kwargs)
            )
        return None

    @tenacity.retry(
        stop=tenacity.stop_after_attempt(5),
        wait=tenacity.wait_random(min=1, max=5),
        retry=(
            tenacity.retry_if_not_exception_type(qbit.UnsupportedMediaType415Error)
            & tenacity.retry_if_not_exception_type(qbit.TorrentFileNotFoundError)
            & tenacity.retry_if_not_exception_type(qbit.TorrentFilePermissionError)
        )
        | tenacity.retry_if_not_result(lambda res: res),
    )
    def _add2(self, *args, **kwargs) -> bool:
        return self._client.torrents_add(*args, **kwargs) == "Ok."

    @tenacity.retry(
        stop=tenacity.stop_after_attempt(5),
        wait=tenacity.wait_random(min=1, max=5),
    )
    def _get_most_recently_added_torrent_hash(self) -> Optional[str]:
        torrents = self._client.torrents_info(sort="added_on", limit=1, reverse=True)
        if len(torrents) == 0:
            raise ValueError("No torrents in qbittorrent")
        return torrents[0]["hash"]
