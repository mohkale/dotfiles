import asyncio
import logging


async def is_alive(host: str, port: int) -> bool:
    """Asynchronously check whether host:port is bound.
    """
    logging.debug("Checking if host=%s port=%d are bound", host, port)
    writer = None
    try:
        _, writer = await asyncio.open_connection(host, port)
        return True
    except OSError:
        return False
    finally:
        if writer is not None:
            writer.close()
            await writer.wait_closed()
