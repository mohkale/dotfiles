"""
Client implementation for the transmission daemon.
"""

import asyncio
import json
import logging

import aiohttp

from ._transmission_base import _TransmissionBase


class AsyncTransmission(_TransmissionBase):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._session = None

    async def __aenter__(self):
        self._session = aiohttp.ClientSession()
        return self

    async def __aexit__(self, *err):
        await self._session.close()
        self._session = None

    async def acheck(self) -> bool:
        """
        Assert whether the current transmission daemon is running
        asynchronously.
        """
        logging.debug(
            "Checking if Transmission daemon is alive at host=%s port=%d",
            self.host,
            self.port,
        )
        reader = writer = None
        try:
            reader, writer = await asyncio.open_connection(self.host, self.port)
            return True
        except OSError:
            return False
        finally:
            if writer is not None:
                writer.close()
                await writer.wait_closed()

    async def _make_request(self, url, data):
        logging.debug("Making request to method with body='%s'", data)
        async with self._session.post(url, data=data) as response:
            if response.status == 409:
                session_id = response.headers["X-Transmission-Session-Id"]
                logging.info(
                    "Session responded with code=409, updating session-id=%s",
                    session_id,
                )
                self._session.headers.update({"X-Transmission-Session-Id": session_id})

                # Try again, with updated session id
                return await self._make_request(url, data)

            response_json = await response.json()
            if response_json["result"] != "success":
                logging.error("Request failed with status=%s", response_json["result"])
            response.raise_for_status()
            return response_json

    async def acommand(self, method: str, **args):
        """Make a request to the tranmission API.

        Parameters
        ----------
        method
            the API method to call, see [[https://raw.githubusercontent.com/transmission/transmission/2.9x/extras/rpc-spec.txt][here]]
        args
            body of the arguments for section of the request
        """
        return await self._make_request(
            self.link, json.dumps({"method": method, "arguments": {**args}})
        )
