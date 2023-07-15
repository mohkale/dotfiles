"""
Client implementation for the transmission daemon.
"""

import json
import logging
import socket

from requests import Session

from ._transmission_base import _TransmissionBase


class Transmission(_TransmissionBase):
    """Simple interface to the transmission RPC API"""

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.session = Session()

    def check(self):
        """
        Assert whether the current transmission daemon is running.
        """
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            try:
                s.connect((self.host, self.port))
                return True
            except socket.error:
                return False

    def _make_request(self, url, data):
        logging.debug("making request to method with body: %s", data)

        response = self.session.post(url, data=data)

        # users session id has expired
        if response.status_code == 409:
            session_id = response.headers["X-Transmission-Session-Id"]
            logging.info(
                "session responded with 409, updating session id to: %s", session_id
            )
            self.session.headers.update({"X-Transmission-Session-Id": session_id})

            # try again, with updated session id
            response = self._make_request(url, data)

        return response

    def command(self, method: str, **args):
        """Make a request to the tranmission API.

        Parameters
        ----------
        method
            the API method to call, see [[https://raw.githubusercontent.com/transmission/transmission/2.9x/extras/rpc-spec.txt][here]]
        args
            body of the arguments for section of the request
        """
        resp = self._make_request(
            self.link, json.dumps({"method": method, "arguments": {**args}})
        )

        resp_json = resp.json()
        if resp_json["result"] != "success":
            logging.error("request failed with status='%s'", resp_json["result"])
        resp.raise_for_status()
        return resp_json
