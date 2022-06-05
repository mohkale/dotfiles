"""
Tmux status line segment for Docker containers.

This file defines a status line segment for inspecting the number and status
of running docker containers. It outputs a docker icon and then one or more
numbers comprising the total running container count. The form of the count
can be just XX if there are no paused, exited or dead containers. Otherwise
it will be XX/ZZ (with ZZ being the total container count and XX being just
the running ones). You can also optionally highlight any containers with
another status outputted of the form XX+YY/ZZ. If you configure docker to show
containers with all statuses or the sum of all the statuses that were printed,
then summary count will be ommited.
"""
import argparse
import enum
import subprocess
from collections import Counter
from distutils.spawn import find_executable as which

from .base import StatusMiscSegment


class DockerStatus(enum.Enum):
    """See https://github.com/moby/moby/blob/b44b5bbc8ba48f50343602a21e7d44c017c1e23d/container/state.go#L74"""

    PAUSED = "paused"
    RESTARTING = "restarting"
    RUNNING = "running"
    DEAD = "dead"
    CREATED = "created"
    EXITED = "exited"


class DockerSegment(StatusMiscSegment):
    """Status line segment showing number of running docker containers."""

    name = "docker"

    def __init__(self, args) -> None:
        if not args.docker_statuses:
            args.docker_statuses = ["running"]

        try:
            args.docker_statuses = [
                DockerStatus[it.upper()] for it in args.docker_statuses
            ]
        except KeyError as err:
            raise ValueError(f"Invalid docker status: {err}") from err

        try:
            args.docker_styles = {
                DockerStatus[key.upper()]: value
                for key, value in (args.docker_styles or tuple())
            }
        except KeyError as err:
            raise ValueError(f"Invalid docker status: {err}") from err

        super().__init__(args)

    @classmethod
    def parser_args(cls, parser: argparse.ArgumentParser) -> None:
        docker_group = parser.add_argument_group("Docker Containers")
        docker_group.add_argument(
            f"--{cls.name}-icon",
            default="D",
            metavar="ICON",
            help="Icon shown to indicate notmuch status.",
        )
        docker_group.add_argument(
            f"--{cls.name}-icon-style",
            default="",
            metavar="STYLE",
            help="Styling for docker icon.",
        )

        docker_group.add_argument(
            f"--{cls.name}-format",
            default="{:02d}",
            help="Format string for docker status counts.",
        )

        docker_group.add_argument(
            f"--{cls.name}-status",
            metavar="STATUS",
            nargs="+",
            dest=f"{cls.name}_statuses",
            choices=[it.name for it in DockerStatus],
            help="Include containers with status in output (default to just running).",
        )
        docker_group.add_argument(
            f"--{cls.name}-status-style",
            nargs=2,
            dest=f"{cls.name}_styles",
            action="append",
            metavar="STATUS STYLE",
            help="Set the STYLE to use for displaying STATUS counts.",
        )

        docker_group.add_argument(
            f"--{cls.name}-total-style",
            default="",
            metavar="STYLE",
            help="Styling for docker summary count.",
        )

        docker_group.add_argument(
            f"--{cls.name}-hide-zero",
            action="store_true",
            help="When true don't show anything if no containers are running",
        )

    def render(self) -> str:
        # pylint: disable=no-member
        if not which("docker"):
            return None
        proc = subprocess.run(
            ["docker", "ps", "--all", "--format", "{{.State}}"],
            check=False,
            capture_output=True,
            encoding="ascii",
        )
        if proc.returncode != 0:
            return None
        counts = Counter(it for it in proc.stdout.split("\n") if it)
        count_total = sum(counts.values())
        if count_total == 0 and self.hide_zero:
            return None

        result = ""
        if self.icon:
            result += self._style(self.icon, self.icon_style) + " "

        count_strings = []
        status_total = 0
        for status in self.statuses:
            count = counts[status.value]
            if count == 0 and self.hide_zero:
                continue
            count_strings.append(
                self._style(self.format.format(count), self.styles.get(status, ""))
            )
            status_total += count
        if count_strings:
            result += "+".join(count_strings)
        if status_total != count_total:
            if count_strings:
                result += "/"
            result += self._style(self.format.format(count_total), self.total_style)
        return result
