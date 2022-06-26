"""Status line segment for showing NordVPN connection status."""

# pylint: disable=no-member

import logging
import subprocess
from distutils.spawn import find_executable as which

from ...shared import run_process
from ..segment import StatusMiscSegment


class NotMuchSegment(StatusMiscSegment):
    """Status line segment showing number of unread emails."""

    name = "notmuch"
    sleep_time = 15

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.tag_styles = {
            "tag:unread": self.unread_style,
            "tag:flagged": self.flagged_style,
        }

    @classmethod
    def parser_args(cls, parser):
        notmuch_group = parser.add_argument_group("Notmuch Mail")
        super().parser_args(notmuch_group)

        notmuch_group.add_argument(
            f"--{cls.name}-icon",
            default="M",
            metavar="ICON",
            help="Icon shown to indicate notmuch status.",
        )
        notmuch_group.add_argument(
            f"--{cls.name}-icon-style",
            default="",
            metavar="STYLE",
            help="Styling for notmuch mail icon",
        )
        notmuch_group.add_argument(
            f"--{cls.name}-unread-style",
            default="",
            metavar="STYLE",
            help="Styling for unread emails.",
        )
        notmuch_group.add_argument(
            f"--{cls.name}-flagged-style",
            default="",
            metavar="STYLE",
            help="Styling for flagged emails.",
        )

        notmuch_group.add_argument(
            f"--{cls.name}-format",
            metavar="FORMAT",
            default="{:02d}",
            help="Format string for notmuch mail counts.",
        )
        notmuch_group.add_argument(
            f"--{cls.name}-hide-zero",
            action="store_true",
            help="When true don't show empty mail entries.",
        )

    # pylint: disable=invalid-overridden-method
    async def render(self):
        # pylint: disable=no-member
        if not which("notmuch"):
            logging.debug(
                "Skipping segment=%s because notmuch is not installed.", self.name
            )
            return None
        # Mapping search queries to the style string to apply for them.
        returncode, stdout, stderr = await run_process(
            ["notmuch", "count", "--output=threads", "--batch"],
            input="\n".join(self.tag_styles.keys()),
            encoding="ascii",
        )
        if returncode != 0:
            logging.warning(
                "Warning failed to run notmuch process for segment=%s", self.name
            )
            return None
        counts = [
            (None if x == "0" and self.hide_zero else (self.format.format(int(x))))
            if x.isdigit()
            else "?"
            for x in stdout.rstrip().split("\n")
        ]
        if len(counts) != len(self.tag_styles):
            logging.error(
                "notmuch: count/search length mismatch: %d/%d",
                len(counts),
                len(self.tag_styles),
            )
            return None
        res = []
        for count, style in zip(counts, self.tag_styles.values()):
            if not count:
                continue
            res.append(self._style(count, style))
        if res and self.icon:
            res.insert(0, self._style(self.icon, self.icon_style))
        return " ".join(res)
