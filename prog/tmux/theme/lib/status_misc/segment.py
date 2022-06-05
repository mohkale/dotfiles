"""Base class for a [[file:~/.config/dotfiles/prog/tmux/theme/status-misc][status-misc]] segment."""

import abc
import asyncio
import logging
import typing
from typing import Awaitable


class StatusMiscSegment(abc.ABC):
    """Root class for a status line segment."""

    sleep_time = 60

    def __init__(self, args):
        logging.info("Initialising %s", self.name)
        self.__dict__.update(
            {
                key.removeprefix(self.name.replace("-", "_") + "_"): value
                for key, value in vars(args).items()
                if key.startswith(self.name.replace("-", "_"))
            }
        )
        self.args = args
        logging.debug("Update interval for %s set to %d", self.name, self.sleep_time)

    @property
    @abc.abstractclassmethod
    def name(cls):
        """The name of the current segment (used in --enable).

        You should define this as a class level attribute of your class,
        such as `name = "foo"`, to properly override this abstract method.
        """

    @classmethod
    def parser_args(cls, parser: "argparse.ArgumentParser") -> None:
        """Assign any command line arguments for this segment.

        Each command line arg should be prefixed by this segments name
        which will make them be assigned as local variables in this
        segment.
        """
        parser.add_argument(
            f"--{cls.name}-sleep-time",
            type=int,
            default=cls.sleep_time,
            metavar="SECONDS",
            help="How long to wait between updating this section.",
        )

    async def run(
        self, callback: typing.Callable[[typing.Optional[str]], Awaitable[None]]
    ) -> None:
        """Create a coroutine to run this segment and pass the result to callback.

        Parameters
        ----------
        callback
            A function which will be passed the result of rendering a status
            segment.
        """
        while True:
            try:
                result = self.render()
            except RuntimeError as err:
                logging.exception(
                    "Error while processing segment %s: %s", self.name, err
                )
            else:
                await callback(result)
            await asyncio.sleep(self.sleep_time)
            logging.debug("Awoke segment=%s", self.name)

    @abc.abstractmethod
    def render(self) -> typing.Optional[str]:
        """Render this status line segment."""

    def _style(self, msg: str, style: typing.Optional[str]) -> None:
        if style:
            msg = style + msg + self.args.reset_style
        return msg
