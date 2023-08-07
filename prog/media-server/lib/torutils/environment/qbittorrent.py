import argparse
import pathlib
from typing import List, NamedTuple, Optional


class ScriptEnvironment(NamedTuple):
    """Variables parsed from the current qBittorrent script environment."""

    name: str
    category: Optional[str]
    tags: List[str]
    content_path: Optional[pathlib.Path]
    root_path: Optional[pathlib.Path]
    save_path: pathlib.Path
    file_count: int
    torrent_size_bytes: int
    current_tracker: str
    info_hash_v1: str
    info_hash_v2: str
    torrent_id: int

    @classmethod
    def from_args(cls, args: argparse.Namespace) -> "ScriptEnvironment":
        """Create a `ScriptEnvironment` from a parsed argparse Namespace."""
        return cls(
            args.torrent_name,
            args.category if args.category else None,
            args.tags.split(",") if args.tags.strip() else [],
            args.content_path,
            args.root_path,
            args.save_path,
            args.file_count,
            args.torrent_size,
            args.current_tracker if args.current_tracker.strip() else None,
            args.info_hash_v1,
            args.info_hash_v2,
            args.torrent_id,
        )


def parse_script_environment(env_group: argparse._ArgumentGroup) -> None:
    """Setup argparse arguments for qBittorrent scripts."""

    def _path_unless_empty(arg: str) -> Optional[pathlib.Path]:
        if not arg.strip():
            return None
        return pathlib.Path(arg)

    """
    --torrent-name "%N"
    --category "%L"
    --tags "%G"
    --content-path "%F"
    --root-path "%R"
    --save-path "%D"
    --file-count "%C"
    --torrent-size "%Z"
    --current-tracker "%T"
    --info-hash-v1 "%I"
    --info-hash-v2 "%J"
    --torrent-id "%K"
    """
    env_group.add_argument(
        "--torrent-name",
        metavar="NAME",
        help="Torrent name: (%%N)",
    )
    env_group.add_argument(
        "--category",
        metavar="CATEGORY",
        help="Torrent category: (%%L)",
    )
    env_group.add_argument(
        "--tags",
        metavar="TAG[,TAG...]",
        help="Torrent tags: (%%G)",
    )
    env_group.add_argument(
        "--content-path",
        metavar="PATH",
        type=_path_unless_empty,
        help="Torrent content path: (%%F)",
    )
    env_group.add_argument(
        "--root-path",
        metavar="PATH",
        type=_path_unless_empty,
        help="Torrent root path: (%%R)",
    )
    env_group.add_argument(
        "--save-path",
        metavar="PATH",
        type=_path_unless_empty,
        help="Torrent save path: (%%D)",
    )
    env_group.add_argument(
        "--file-count",
        metavar="COUNT",
        type=int,
        help="Torrent number of files: (%%C)",
    )
    env_group.add_argument(
        "--torrent-size",
        metavar="BYTES",
        type=int,
        help="Torrent size in bytes: (%%Z)",
    )
    env_group.add_argument(
        "--current-tracker",
        metavar="TRACKER",
        help="Torrent current tracker: (%%T)",
    )
    env_group.add_argument(
        "--info-hash-v1",
        metavar="HASH",
        help="Torrent info hash v1: (%%I)",
    )
    env_group.add_argument(
        "--info-hash-v2",
        metavar="HASH",
        help="Torrent info hash v2: (%%J)",
    )
    env_group.add_argument(
        "--torrent-id",
        metavar="ID",
        help="Torrent id: (%%K)",
    )
