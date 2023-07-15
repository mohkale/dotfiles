"""
torrent-added script helpers.

The routines in this script will be invoked every time a new torrent is added to
Transmission. At the moment all it does is detect when the new torrent is created
with a "specific" label and move it to a different incomplete torrent directory
compared to the default directory. See the "downloadDirectoryLabels" configuration
option in watcher.json for more information about how this is configured.
"""

import logging
import pathlib
from typing import Any, List

from . import backend, watcher


async def torrent_added(
    torrent_backend: backend.TorrentBackend,
    torrent_id: Any,
    torrent_location: pathlib.Path,
    torrent_labels: List[str],
    watcher_config: watcher.WatcherConfig,
    dry_run: bool,
) -> bool:
    intended_root = next(
        (
            root
            for label, root in watcher_config.download_directory_labels.items()
            if label in torrent_labels
        ),
        None,
    )
    if intended_root is None:
        logging.info(
            "Skipping file=%s because it has no tracked labels",
            torrent_location,
        )
        return True

    root = next(
        (
            root
            for root in watcher_config.download_dirs
            if torrent_location.is_relative_to(root)
        ),
        None,
    )
    if root is None:
        logging.info(
            "Skipping file=%s because it is not in a download root",
            torrent_location,
        )
        return True

    incomplete_dir = root / watcher_config.incomplete_subdir
    if not torrent_location.is_relative_to(incomplete_dir):
        logging.info(
            "Skipping file=%s it is not in the incomplete directory=%s",
            torrent_location,
            incomplete_dir,
        )
        return True

    if root == intended_root:
        logging.info(
            "Skipping file=%s is in its intended root directory=%s",
            torrent_location,
            intended_root,
        )
        return True

    destination = intended_root / watcher_config.incomplete_subdir
    logging.info("Moving file=%s to dest=%s", torrent_location, destination)
    if dry_run:
        logging.info("Skipping actually moving file because dry-run=True")
        return True

    async with torrent_backend.client() as client:
        if not await client.move(torrent_id, str(destination)):
            logging.exception(
                "Failed to move file=%s to dest=%s", torrent_location, destination
            )
            return False
    return True
