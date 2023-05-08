"""Shared utilities for my theme scripts."""
import asyncio
import logging
import sys
import time
from typing import Callable, Generator, List, Optional, Tuple

# Maximum duration before which a status script MUST output something.
# This is required to prevent tmux auto-killing the process because it's
# been silent for too long. See `format_job_tidy' in [[orgit:tmux][tmux]]/format.c.
MAX_OUTPUT_INTERVAL = 3600 * 0.95


async def async_print_loop(
    pointer: List[str],
    event: asyncio.Event,
    unbuffer: bool = False,
    sleep: int = 600,
) -> None:
    """Run a print loop asynchronously.

    This function constructs an asyncrous event loop which continually
    prints changes to a string pointed to by `pointer`.

    Parameters
    ----------
    pointer
        A pointer to a formatted string that should be printed once this
        function is woken up. For technical reasons this is a list that
        should only contain one element (the string to be printed).
    event
        An async event which will be raised once the value pointed to by
        `pointer` might have changed. Use this to trigger an immediate
        wake up of the print event loop.
    unbuffer
        Whether the standard output stream should be flushed after printing.
    sleep
        A minimum timeout period within which this function should have been
        awoken at least once. This is used to automatically ensure the print
        loop periodically regains control even when none of the statuses have
        been changed.
    """
    last_line = None
    last_print = 0

    while True:
        line = " ".join(pointer)
        if line != last_line or time.time() - last_print >= MAX_OUTPUT_INTERVAL:
            print(line)
            last_print = time.time()
            last_line = line
            if unbuffer:
                sys.stdout.flush()

        # Either wait until something has changed or we've reached sleep period
        # and should redraw anyways.
        done, pending = await asyncio.wait(
            [
                asyncio.create_task(event.wait()),
                asyncio.create_task(asyncio.sleep(sleep)),
            ],
            return_when=asyncio.FIRST_COMPLETED,
        )
        for future in pending:
            future.cancel()

        event.clear()
        logging.debug("Awoke print event loop with future=%s", done)


async def run_process(
    cmd: List[str],
    input: Optional[str] = None,  # pylint: disable=redefined-builtin
    encoding: str = "utf-8",
) -> Tuple[int, str, str]:
    """Run `cmd` and return the process returncode and stdout+stderr streams.

    Parameters
    ----------
    cmd
        Command line to execute.
    """
    logging.debug("Starting cmd=%s", cmd)
    proc = await asyncio.create_subprocess_exec(
        cmd[0],
        *cmd[1:],
        stdin=asyncio.subprocess.DEVNULL if input is None else asyncio.subprocess.PIPE,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )

    logging.debug("Waiting for cmd to finish cmd=%s", cmd)
    stdout, stderr = await proc.communicate(None if input is None else input.encode())
    logging.debug("Command exited with returncode=%s cmd=%s", proc.returncode, cmd)
    return proc.returncode, stdout.decode(encoding), stderr.decode(encoding)


def render_loop(wrap: Callable[[], str]) -> Generator[str, None, None]:
    """Call and generate items from `wrap`, silently suppressing any errors.

    Parameters
    ----------
    wrap
        A callable that takes no arguments and should return a string.
    """
    while True:
        try:
            yield wrap()
        except StopIteration:
            return
        except GeneratorExit:
            break
        except RuntimeError as err:  # pylint: disable=broad-except,unused-variable
            logging.exception("Error while processing segment %s: %s", self.name, err)
            yield ""


def print_loop(
    iterator: Generator[str, None, None],
    unbuffer: bool = False,
    sleep: Optional[int] = None,
) -> None:
    """Read lines to output from `it` performing the minimum number of writes
    required by tmux.

    Parameters
    ----------
    iterator
        Generator that should continually generate lines to output.
    unbuffer
        Whether to flush output stream after every write attempt.
    sleep
        How long to wait between sequential requests to `it`.

    """
    last_output = None  # The last string we printed.
    last_print = 0  # The last time we printed at.
    for line in iterator:
        if line != last_output or time.time() - last_print >= MAX_OUTPUT_INTERVAL:
            print(line)
            last_print = time.time()
            last_output = line
            if unbuffer:
                sys.stdout.flush()
        if not sleep:
            break
        time.sleep(sleep)
