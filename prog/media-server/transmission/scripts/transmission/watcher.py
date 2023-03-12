"""transmission-watcher script helper module."""

import dataclasses
import enum
import functools
import json
import os
import pathlib
import re
from typing import Any, Dict, List, NamedTuple, Optional, Tuple

from ._transmission_base import CONFIG_DIR

# Default config file path.
WATCHER_FILE = CONFIG_DIR / "watcher.json"


class WatcherSuffixes(enum.Enum):
    """Suffixes of files that can be added to Transmission by the watcher."""

    TORRENT = ".torrent"
    MAGNET = ".magnet"

    @classmethod
    def has_member(cls, name: str) -> bool:
        """Assert whether this enumeration contains `name`."""
        try:
            cls(name)
        except ValueError:
            return False
        return True


# Mapping from a directory to a set of overrides for it.
_Rule = Dict[str, Dict[str, Any]]


# Simple file-name substitution from absolute path src to dest.
class _ContainerRemappings(NamedTuple):
    src: pathlib.Path
    dest: pathlib.Path


# Mapping from label to the intended download root for new torrents with that
# label.
_LabelMoves = Dict[str, pathlib.Path]


@dataclasses.dataclass(frozen=True)
class WatcherConfig:
    """Transmission watcher configuration.

    For a description of the fields in this class see the example configuration file
    at [[file:~/.config/dotfiles/prog/media-server/transmission/watcher.json][watcher.json]].
    """

    download_dirs: List[pathlib.Path]
    container_remappings: List[_ContainerRemappings]
    added_dir: pathlib.Path
    incomplete_subdir: pathlib.Path
    watch_subdir: pathlib.Path
    complete_subdir: pathlib.Path
    download_directory_labels: _LabelMoves
    rules: _Rule

    @classmethod
    def from_json(cls, json_dict: Dict) -> "WatcherConfig":
        """Convert a deserialised configuration file to a `WatcherConfig` object."""
        download_dirs = [
            pathlib.Path(os.path.expandvars(it))
            for it in json_dict["downloadDirectories"]
        ]

        container_remappings = []
        for it in json_dict["containerVolumeRemappings"]:
            # In the container src=dest so this is redundant.
            it_src = pathlib.Path(os.path.expandvars(it["src"]))
            it_dest = pathlib.Path(os.path.expandvars(it["dest"]))
            if it_src != it_dest:
                container_remappings.append(_ContainerRemappings(it_src, it_dest))

        added_directory = pathlib.Path(os.path.expandvars(json_dict["addedDirectory"]))

        subdirs = json_dict["subDirectories"]
        incomplete_subdir = pathlib.Path(subdirs["incomplete"])
        watch_subdir = pathlib.Path(subdirs["watch"])
        complete_subdir = pathlib.Path(subdirs["complete"])

        download_directory_labels = {
            it["label"]: download_dirs[it["downloadDirectoryIndex"]]
            for it in json_dict["downloadDirectoryLabels"]
        }

        rules = {
            it["directory"]: it["overrides"] for it in json_dict["torrentAddRules"]
        }

        return cls(
            download_dirs,
            container_remappings,
            added_directory,
            incomplete_subdir,
            watch_subdir,
            complete_subdir,
            download_directory_labels,
            rules,
        )

    @classmethod
    def from_file(cls, file: pathlib.Path) -> "WatcherConfig":
        """Read a configuration file into a new `WatcherConfig` object."""
        with file.open("r", encoding="utf-8") as fh:
            contents, _ = re.subn(r"^\s*//.*$", "", fh.read(), flags=re.MULTILINE)
        return cls.from_json(json.loads(contents))

    def calc_overrides(self, path: pathlib.Path) -> Tuple[pathlib.Path, Dict[str, Any]]:
        """Determine torrent-add request overrides."""
        overrides = {}
        while len(path.parts) > 1 and path.parts[0] in self.rules:
            overrides.update(self.rules[path.parts[0]])
            path = pathlib.Path(*path.parts[1:])
        return path, overrides

    def remap_for_container(self, file: pathlib.Path) -> pathlib.Path:
        """Remap `file` into the equivalent path for it outside of a container."""
        for src, dest in self.container_remappings:
            try:
                file_relative_to_src = file.relative_to(src)
            except ValueError:
                # Not relative to the src path so skip it.
                continue
            else:
                return dest / file_relative_to_src
        return file
