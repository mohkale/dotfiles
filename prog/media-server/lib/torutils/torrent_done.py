"""
torrent-done script helpers.

The routines in this script will be invoked the every time a torrent completes.
Currently this script is setup to move torrents from the initial incomplete torrent
directory into a complete directory. The complete directory will either be a
directory matching the original torrent file in the added-torrents directory or if
none can be found then "random". This script will ONLY move files from the incomplete
directory and will never move them outside of the download folder their contained in.
"""

import asyncio
import glob
import logging
import pathlib
from typing import Any, NamedTuple, Optional

from . import backend, notify, watcher


def _find_download_root(
    location: pathlib.Path, watcher_config: watcher.WatcherConfig
) -> Optional[pathlib.Path]:
    """Find root directory for the torrent downloaded to `location`.

    Parameters
    ----------
    location
        Path where a torrent has been downloaded to.
    watcher_config
        Watcher daemon configuration file.
    """
    for root in watcher_config.download_dirs:
        if location.is_relative_to(root):
            return root
    return None


class _DestPath(NamedTuple):
    # The directory where the torrent should be moved to (not including the
    # name of the torrent).
    dest_dir: pathlib.Path

    # The source file the torrent was added from with the [[file:~/.config/dotfiles/prog/media-server/transmission/cmds/transmission-watcher][transmission-watcher]]
    # if it exists. This file should be removed after the torrent is moved to
    # its new location.
    added_file: Optional[pathlib.Path]


def _calculate_dest_path(
    hash_: str,
    watcher_config: watcher.WatcherConfig,
    root: pathlib.Path,
) -> _DestPath:
    """Determine a destination path for a completed torrent.

    Looks for a matching .magnet and .torrent file in the added torrents
    directory and if it exists reuse the path for it relative to the added
    directory. Otherwise place in the default completion subdirectory of
    the current download root.def __str__(self):
    """
    default = root / watcher_config.complete_subdir

    # We glob for any file prefixes with the torrent hash and then
    # filter out files with unexpected file-names or invalid suffixes
    files_with_hash = glob.iglob(
        f"**/{glob.escape(hash_)}.*",
        root_dir=watcher_config.added_dir,
        recursive=True,
    )
    for file_relative_ in files_with_hash:
        file_relative = pathlib.Path(file_relative_)
        file = watcher_config.added_dir / file_relative
        if file.stem == hash_ and watcher.WatcherSuffixes.has_member(file.suffix):
            logging.info("Found src file=%s for torrent with hash=%s", file, hash_)
            # As a special case to avoid cluttering the main download directory we
            # push any files that would ordinarily be put in this directory into
            # the default complete directory.
            if str(file_relative.parent) == ".":
                return _DestPath(default, file)
            return _DestPath(root / file_relative.parent, file)

    return _DestPath(default, None)


# pylint: disable=too-many-return-statements
async def _move_completed_torrent(
    torrent_backend: backend.TorrentBackend,
    id_: Any,
    hash_: str,
    location: pathlib.Path,
    watcher_config: watcher.WatcherConfig,
    dry_run: bool,
    skip_move: bool,
) -> bool:
    """Move a just completed torrent into a completed download directory."""
    if not location.exists():
        logging.warning("Not moving file=%s because it no longer exists", location)
        return False

    root = _find_download_root(location, watcher_config)
    if root is None:
        logging.info("Not moving file=%s because it isn't in a download root", location)
        return True

    incomplete_dir = root / watcher_config.incomplete_subdir
    if not location.is_relative_to(incomplete_dir):
        logging.info(
            "Not moving file=%s because it isn't in the incomplete-directory=%s",
            location,
            incomplete_dir,
        )
        return True

    logging.debug("Determining destination for file=%s", location)
    destination, added_file = _calculate_dest_path(hash_, watcher_config, root)
    if destination == location:
        logging.warning(
            "Not moving file=%s to dest=%s because their the same",
            location,
            destination,
        )
        return True

    if skip_move:
        logging.info(
            "Skipping moving file=%s to dest=%s due to predicate", location, destination
        )
    else:
        logging.info("Moving file=%s to dest=%s", location, destination)
        if dry_run:
            logging.info("Skipping actually moving file because dry-run=True")
            return True

        async with torrent_backend.client() as client:
            if not await client.move(id_, str(destination)):
                logging.exception(
                    "Failed to move file=%s to dest=%s", location, destination
                )
                if added_file is not None:
                    new_added_file = added_file.parent / (
                        added_file.stem + ".completed"
                    )
                    logging.info(
                        "Moving source file=%s to dest=%s", added_file, new_added_file
                    )
                    added_file.rename(new_added_file)
                return False

    # If the torrent was moved sucesfully, we no longer have any need for
    # the watch file the torrent was added with so it can be removed.
    if added_file is not None:
        added_file.unlink()

    return True


async def torrent_done(
    torrent_backend: backend.TorrentBackend,
    torrent_name: str,
    torrent_id: Any,
    torrent_hash: str,
    torrent_location: pathlib.Path,
    watcher_config: watcher.WatcherConfig,
    dry_run: bool,
    skip_move: bool = False,
) -> bool:
    tasks = []
    tasks.append(notify.notify_complete(torrent_backend, torrent_name))
    tasks.append(
        _move_completed_torrent(
            torrent_backend,
            torrent_id,
            torrent_hash,
            torrent_location,
            watcher_config,
            dry_run,
            skip_move,
        )
    )

    result = True
    task_results = await asyncio.gather(*tasks, return_exceptions=True)
    for task_result in task_results:
        if isinstance(task_result, Exception):
            logging.exception(
                "Encountered exception while awaiting tasks",
                exc_info=task_result,
            )
            result = False
        elif not task_result:  # bool result, and result is bad
            result = False
    return result
