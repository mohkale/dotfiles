#!/usr/bin/env python3
"""
Shared helpers for tmux status scripts.
"""

import time
import sys

# Maximum duration before which a status script MUST output something.
# This is required to prevent tmux auto-killing the process because it's
# been silent for too long. See `format_job_tidy' in [[orgit:tmux][tmux]]/format.c.
MAX_OUTPUT_INTERVAL = 3600 * 0.95

def render_loop(wrap):
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
        except Exception:  # pylint: disable=broad-except
            yield ''

def print_loop(it, unbuffer=False, sleep=False):
    """Read lines to output from `it` performing the minimum number of writes required.

    Parameters
    ----------
    it
      Generator that should continually generate lines to output.
    unbuffer
      Whether to flush output stream after every write attempt.
    sleep
      How long to wait between sequential requests to `it`.

    """
    last_output = None                                                          # The last string we printed.
    last_print = 0                                                              # The last time we printed at.
    for line in it:
        if line != last_output or time.time() - last_print >= MAX_OUTPUT_INTERVAL:
            print(line)
            last_print = time.time()
            last_output = line
            if unbuffer:
                sys.stdout.flush()
        if not sleep:
            break
        time.sleep(sleep)
