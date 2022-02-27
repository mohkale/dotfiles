"""Base class for a [[file:~/.config/dotfiles/prog/tmux/theme/status-misc][status-misc]] segment."""

import abc
import typing

class StatusMiscSegment(abc.ABC):
    """Root class for a status line segment.
    """

    def __init__(self, args):
        self.__dict__.update({key.removeprefix(self.name.replace('-', '_') + '_'): value
                              for key, value in vars(args).items()
                              if key.startswith(self.name.replace('-', '_'))})
        self.args = args

    @property
    @abc.abstractmethod
    def name(self):
        """The name of the current segment (used in --enable)."""

    @classmethod
    @abc.abstractmethod
    def parser_args(cls, parser):
        """Assign any command line arguments for this segment.

        Each command line arg should be prefixed by this segments name
        which will make them be assigned as local variables in this
        segment.
        """

    @abc.abstractmethod
    def render(self) -> typing.Optional[str]:
        """Render this status line segment."""

    def _style(self, msg, style):
        if style:
            msg = style + msg + self.args.reset_style
        return msg
