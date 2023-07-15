import asyncio
import logging
import shlex
import subprocess

from . import backend


async def notify_complete(backend: backend.TorrentBackend, name: str) -> bool:
    """Send a notification that a torrent has completed."""
    title = "Completed torrent"
    msg = name
    cmd = [
        "notify-send",
        "--icon",
        "torrents",
        "--app-name",
        backend.title,
        "--category",
        "transfer.complete",
        title,
        msg,
    ]

    logging.debug(
        'Running notification command="%s"',
        " ".join(shlex.quote(arg) for arg in cmd),
    )
    proc = await asyncio.create_subprocess_exec(
        *cmd,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    stdout, stderr = await proc.communicate()
    if proc.returncode == 0:
        return True

    logging.error("Failed to notify for completed torrent")
    logging.error("[stdout] %s", stdout.decode())
    logging.error("[stderr] %s", stderr.decode())
    return False
