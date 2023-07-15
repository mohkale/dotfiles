"""
Transmission script environment.
"""
import argparse
import os
import pathlib
from typing import List, NamedTuple, Set


class ScriptEnvironment(NamedTuple):
    """Variables parsed from the current Transmission script environment."""

    app_version: str
    localtime: str
    directory: pathlib.Path
    hash: str
    name: str
    bytes_downloaded: int
    id: int
    labels: Set[str]
    trackers: Set[str]

    @classmethod
    def from_args(cls, args: argparse.Namespace) -> "ScriptEnvironment":
        """Create a `ScriptEnvironment` from a parsed argparse Namespace."""
        return cls(
            args.app_version,
            args.local_time,
            pathlib.Path(args.directory),
            args.hash,
            args.name,
            args.bytes_downloaded,
            args.id,
            set(args.labels),
            set(args.trackers),
        )


def parse_script_environment(env_group: argparse._ArgumentGroup) -> None:
    """Setup argparse arguments for Transmission scripts."""

    # For list of supported environment variables see [[https://github.com/transmission/transmission/blob/0ee93068bb45004c5430496b2c14057633d33eae/libtransmission/torrent.cc#L1641][here]].
    tr_app_version = os.getenv("TR_APP_VERSION")
    tr_time_localtime = os.getenv("TR_TIME_LOCALTIME")
    tr_torrent_dir = os.getenv("TR_TORRENT_DIR")
    tr_torrent_hash = os.getenv("TR_TORRENT_HASH")
    tr_torrent_name = os.getenv("TR_TORRENT_NAME")

    tr_torrent_bytes_downloaded = None
    if "TR_TORRENT_BYTES_DOWNLOADED" in os.environ:
        tr_torrent_bytes_downloaded = int(os.environ["TR_TORRENT_BYTES_DOWNLOADED"])

    tr_torrent_id = None
    if "TR_TORRENT_ID" in os.environ:
        tr_torrent_id = int(os.environ["TR_TORRENT_ID"])

    tr_torrent_labels: List[str] = []
    if "TR_TORRENT_LABELS" in os.environ:
        tr_torrent_labels.extend(os.environ["TR_TORRENT_LABELS"].split(","))

    tr_torrent_trackers: List[str] = []
    if "TR_TORRENT_TRACKERS" in os.environ:
        tr_torrent_trackers.extend(os.environ["TR_TORRENT_TRACKERS"].split(","))

    env_group.add_argument(
        "--app-version",
        default=tr_app_version,
        metavar="VERSION",
        help=f"Version of the transmission server running (default: {tr_app_version!r}).",
    )
    env_group.add_argument(
        "--local-time",
        default=tr_time_localtime,
        metavar="TIME",
        help=f"Local time when this script was invoked (default: {tr_time_localtime!r}).",
    )
    env_group.add_argument(
        "-d",
        "--directory",
        default=tr_torrent_dir,
        metavar="DIR",
        help=f"The absolute path to the directory containing NAME (default: {tr_torrent_dir!r}).",
    )
    env_group.add_argument(
        "-H",
        "--hash",
        default=tr_torrent_hash,
        help=f"Hash for the completed torrent (default: {tr_torrent_hash!r}).",
    )
    env_group.add_argument(
        "-n",
        "--name",
        default=tr_torrent_name,
        metavar="NAME",
        help=f"Name of file/directory where torrent is located (default: {tr_torrent_name!r}).",
    )
    env_group.add_argument(
        "--bytes-downloaded",
        default=tr_torrent_bytes_downloaded,
        type=int,
        metavar="COUNT",
        help=f"Number of bytes downloaded for this torrent (default: {tr_torrent_bytes_downloaded})",
    )
    env_group.add_argument(
        "-i",
        "--id",
        default=tr_torrent_id,
        type=int,
        metavar="ID",
        help=f"Id for the completed torrent (default: {tr_torrent_id!r}).",
    )
    env_group.add_argument(
        "-t",
        "--labels",
        default=tr_torrent_labels,
        action="append",
        metavar="LABEL",
        help=f"Labels associated with torrent (default: {tr_torrent_labels!r}).",
    )
    env_group.add_argument(
        "--trackers",
        default=tr_torrent_trackers,
        action="append",
        metavar="TRACKER",
        help=f"Trackers associated with torrent (default: {tr_torrent_trackers!r}).",
    )
