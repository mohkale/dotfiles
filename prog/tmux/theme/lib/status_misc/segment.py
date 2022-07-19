"""Base class for a [[file:~/.config/dotfiles/prog/tmux/theme/status-misc][status-misc]] segment."""

import abc
import argparse
import asyncio
import logging
import sys
from typing import Awaitable, Callable, List, Optional

from ..shared import async_print_loop


def shared_arguments(parser: argparse.ArgumentParser) -> None:
    """Shared command line arguments for status-misc scripts."""
    parser.add_argument(
        "--suffix", metavar="FORMAT", default="", help="Suffix output with FORMAT."
    )
    parser.add_argument(
        "--log-level",
        metavar="LEVEL",
        type=lambda x: getattr(logging, x.upper()),
        default=logging.FATAL,
    )
    parser.add_argument(
        "-r",
        "--reset-style",
        default="#[default]",
        help="Specify style for resetting styles",
    )
    parser.add_argument(
        "-u",
        "--unbuffer",
        action="store_true",
        help="Immeadiately flush output after writing",
    )


class StatusMiscSegment(abc.ABC):
    """Root class for a status line segment."""

    sleep_time = 60

    def __init__(self, args: argparse.Namespace, ignore_prefix: bool = False) -> None:
        logging.info("Initialising %s", self.name)
        self.__dict__.update(
            vars(args).items()
            if ignore_prefix
            else {
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
    def parser_args(
        cls, parser: argparse.ArgumentParser, flag: Callable[[str], str]
    ) -> None:
        """Assign any command line arguments for this segment.

        Each command line arg should be prefixed by this segments name
        which will make them be assigned as local variables in this
        segment.
        """
        parser.add_argument(
            flag("sleep-time"),
            type=int,
            default=cls.sleep_time,
            metavar="SECONDS",
            help="How long to wait between updating this section.",
        )

    async def run(self, callback: Callable[[Optional[str]], Awaitable[None]]) -> None:
        """Create a coroutine to run this segment and pass the result to callback.

        Parameters
        ----------
        callback
            A function which will be passed the result of rendering a status
            segment.
        """
        while True:
            try:
                if asyncio.iscoroutinefunction(self.render):
                    result = await self.render()
                else:
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
    def render(self) -> Optional[str]:
        """Render this status line segment."""

    def _style(self, msg: str, style: Optional[str]) -> None:
        if style:
            msg = style + msg + self.args.reset_style
        return msg

    @classmethod
    def main(cls):
        """Main function for running segment as stand-alone script."""
        # Parse command line arguments
        parser = argparse.ArgumentParser()
        shared_arguments(parser)
        cls.parser_args(parser, lambda flag: f"--{flag}")
        args = parser.parse_args()
        logging.basicConfig(level=args.log_level, stream=sys.stderr)

        cls_instance = cls(args, ignore_prefix=True)

        # Shared state variables for segment runtime
        last_result = None
        value_ptr = [""]

        # segment.run callback function which populates value_ptr.
        def segment_callback(change_event: asyncio.Event):
            async def implementation(result: Optional[str]) -> None:
                nonlocal last_result
                if last_result != result:
                    logging.debug(
                        "Updating value of segment to value=%s",
                        repr(result),
                    )
                    last_result = result
                    line = result
                    if line:
                        line = line + args.suffix
                    value_ptr[0] = line or ""
                    change_event.set()

            return implementation

        # Async main function which runs segment as is.
        async def amain() -> None:
            change_event = asyncio.Event()
            segment_task = asyncio.create_task(
                cls_instance.run(segment_callback(change_event))
            )
            await asyncio.create_task(
                async_print_loop(value_ptr, change_event, args.unbuffer)
            )
            segment_task.cancel()

        try:
            asyncio.run(amain())
        except KeyboardInterrupt:
            sys.exit(1)
