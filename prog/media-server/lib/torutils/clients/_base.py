import abc
import pathlib
from types import TracebackType
from typing import Any, Dict, Optional, Type


class _WatcherClientMixin(abc.ABC):
    __metaclass__ = abc.ABCMeta

    @abc.abstractmethod
    async def is_alive(self) -> bool:
        """Assert whether daemon is up or not."""

    @abc.abstractmethod
    async def add_torrent(
        self,
        file: pathlib.Path,
        translated_file: pathlib.Path,
        overrides: Dict[str, Any],
    ) -> Optional[str]:
        """Add a torrent file to the client."""

    @abc.abstractmethod
    async def add_magnetlink(
        self, magnetlink: str, overrides: Dict[str, Any]
    ) -> Optional[str]:
        """Add a magnetlink to the client."""


class _TorrentMoveMixin(abc.ABC):
    __metaclass__ = abc.ABCMeta

    @abc.abstractmethod
    async def move(self, torrent_id: Any, dest: str) -> bool:
        """Update the location of a torrent."""


class TorrentClient(_WatcherClientMixin, _TorrentMoveMixin, abc.ABC):
    """Abstract interface for a torrent client.
    """
    __metaclass__ = abc.ABCMeta

    @abc.abstractmethod
    async def __aenter__(self) -> None:
        pass

    @abc.abstractmethod
    async def __aexit__(
        self,
        exc_type: Optional[Type[BaseException]],
        exc_val: Optional[BaseException],
        exc_tb: Optional[TracebackType],
    ) -> None:
        pass
