#!/usr/bin/env python3
"""
Determine the approriate destination for a completed transmission torrent download.

See the [[file:~/.dotfiles/programs/transmission/README.org][README]].
"""

import json
import logging
import pathlib as p

from watch_config import WatchConfig


def Path(path):
    """Convert to a path and expand any ~user calls."""
    return p.Path(path).expanduser()


def relative_p(path, parent):
    """Assert whether `path` is relative to `parent`."""
    # TODO switch to optimised
    return parent in path.parents


def normal_download_directory(location, incomplete):
    """Assert whether `location` is in the directory it's normally
    supposed to be downloaded in.
    """
    if not incomplete:
        logging.warning("no incomplete downloads directory supplied")
        # don't know where you normally download to, so not normal dir
        return False

    return relative_p(location, incomplete)


def check_watch_hirearchy(torrent: p.Path, config) -> str:
    """check a users watch directory configuration to determine where a
    torrent should be placed.

    For example, if a user is watching `~/torrents' and the current torrent
    is placed in `~/torrents/foo/bar/' then return `foo/bar'.

    Parameters
    ----------
    torrent
        path to the torrent from which we've been downloading
    config
        path to users watcher configuration, see ./watcher
    """
    if not config:
        logging.warning("no watcher config supplied, skipping watch check")
        return None

    if not torrent:
        logging.warning("no torrent file supplied, skipping watch check")
        return None

    if not isinstance(config, WatchConfig):
        with config as fd:
            config = WatchConfig(json.load(fd))

    for watch_dir in (config.added / x["directory"] for x in config.rules):
        if watch_dir.exists() and relative_p(torrent, watch_dir):
            return torrent.parent.relative_to(watch_dir)
    return None


def check_incomplete_hirearchy(location: p.Path, incomplete: p.Path) -> str:
    """check the current location (where it was downloaded) to determine
    where a torrent should be placed.

    For example, if torrents are normally downloaded to `~/getting' but the
    current location is actually in `~/getting/foo/bar' then return foo/bar.

    Parameters
    ----------
    location
        the full path to where the torrent was downloaded.
    incomplete
        where in progress (downloading) torrents are placed.
    """
    if relative_p(location, incomplete):
        relative = location.parent.relative_to(incomplete)
        if str(relative) != ".":
            return relative
    return None


def check_hirearchy(args):
    """Proxy for `check_incomplete_hirearchy` and `check_watch_hirearchy`."""
    return check_incomplete_hirearchy(
        args.location, args.incomplete
    ) or check_watch_hirearchy(args.torrent, args.watch)


def get_dest_directory(args):
    """determine where a torrent should be placed."""
    dest = args.default
    if not dest:
        logging.warning("No default destination supplied")
    else:
        logging.debug("Default destination set to %s", dest)

    if normal_download_directory(args.location, args.incomplete):
        if not args.downloads:
            logging.warning("no downloads root supplied, ignoring structure checks")
        else:
            logging.info("Finding destination directory based on hirearchy")
            hirearchy = check_hirearchy(args)
            if hirearchy and str(hirearchy) != ".":
                dest = args.downloads / hirearchy
                logging.debug("Destination set to %s", dest)
    else:
        logging.warning(
            "Not moving download directory because %s is not a subdirectory of %s",
            repr(str(args.location)),
            repr(str(args.incomplete)),
        )
        dest = None  # keep download in it's current, non-normal, location

    return dest


if __name__ == "__main__":
    import argparse

    from mohkale.pylog.config import use_config as use_logging_config

    parser = argparse.ArgumentParser()
    parser.add_argument("id", help="tranmission id for torrent")
    parser.add_argument("torrent", type=Path, help="path to torrent file")
    parser.add_argument("location", type=Path, help="current location of download")

    config_group = parser.add_argument_group("config")
    config_group.add_argument(
        "-r",
        "--downloads",
        metavar="DIR",
        type=Path,
        help="root directory for downloads",
    )
    config_group.add_argument(
        "-d",
        "--default",
        metavar="DIR",
        type=Path,
        help="default directory to put complete downloads",
    )
    config_group.add_argument(
        "-i",
        "--incomplete",
        metavar="DIR",
        type=Path,
        help="directory where incomplete downloads are placed",
    )
    config_group.add_argument(
        "-w",
        "--watch",
        metavar="FILE",
        type=argparse.FileType("r", encoding="utf8"),
        help="path to default watcher config file",
    )
    parser.add_argument(
        "-l",
        "--log-level",
        metavar="LEVEL",
        type=lambda x: getattr(logging, x.upper()),
        help="verbosity of logging output",
    )

    args = parser.parse_args()
    vargs = vars(args)

    use_logging_config("dest_path", level=vargs.pop("log_level"))

    dest = get_dest_directory(args)
    if dest:
        print(str(dest))
