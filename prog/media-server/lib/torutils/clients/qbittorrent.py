import json
import logging
import pathlib
from types import TracebackType
from typing import Any, Dict, List, Optional, Type

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
            try:
                last_torrent_hash = self._get_most_recently_added_torrent_hash()[0]
            except IndexError:
                last_torrent_hash = None

            if not self._add2(*args, **kwargs):
                return None

            attempt = 1
            while attempt <= 10:
                attempt += 1

                recent_torrent_hashes = self._get_most_recently_added_torrent_hash(
                    count=5
                )
                if last_torrent_hash is None:
                    next_position = 0
                else:
                    try:
                        last_torrent_hash_position = recent_torrent_hashes.index(
                            last_torrent_hash
                        )
                    except ValueError:
                        logging.error(
                            "Failed to find last torrent hash=%s in current torrent list",
                            last_torrent_hash,
                        )
                        continue
                    else:
                        next_position = last_torrent_hash_position - 1

                if next_position < 0:
                    continue
                if next_position != 0:
                    logging.warning(
                        "Multiple candidate torrent hashes in recent torrent hash list"
                    )

                return recent_torrent_hashes[next_position]
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
    def _get_most_recently_added_torrent_hash(self, count: int = 1) -> List[str]:
        torrents = self._client.torrents_info(
            sort="added_on", limit=count, reverse=True
        )
        if len(torrents) == 0:
            raise ValueError("No torrents in qbittorrent")
        return [it["hash"] for it in torrents]
