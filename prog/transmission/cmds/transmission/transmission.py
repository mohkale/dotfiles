"""
Client implementation for the transmission daemon.
"""

import json
import socket
import logging
import pathlib as p
from requests import Session

CONFIG_DIR   = p.Path('~/.config/transmission-daemon').expanduser()
CONFIG_FILE  = CONFIG_DIR / 'settings.json'

class Transmission(object):
    """Simple interface to the transmission RPC API"""
    def __init__(self,
                 host: str = 'localhost',
                 port: int = 9091,
                 path: str = '/transmission/rpc'):
        self.host = host
        self.port = port
        self.path = path

        self.session = Session()

    @classmethod
    def from_conf(cls, conf: object):
        """Create a Transmission instance from a transmission-daemon JSON config file.
        """
        return cls(conf.get('rpc-bind-address', 'localhost'),
                   conf.get('rpc-port', 9091),
                   conf.get('rpc-url', '/transmission/') + 'rpc')

    @classmethod
    def from_conf_file(cls, conf: p.Path = CONFIG_FILE):
        """Alis for `self.from_conf` which automatically opens and reads `conf`.
        """
        return cls.from_conf(json.loads(conf.open().read()))

    def check(self):
        """
        Assert whether the current transmission daemon is running.
        """
        return self._socket_active(self.host, self.port)

    def _make_request(self, url, data):
        logging.debug('making request to method with body: %s', data)

        response = self.session.post(url, data=data)

        # users session id has expired
        if response.status_code == 409:
            session_id = response.headers['X-Transmission-Session-Id']
            logging.info(
                'session responded with 409, updating session id to: %s', session_id)
            self.session.headers.update({'X-Transmission-Session-Id': session_id})

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
            self.link,
            json.dumps({
                'method': method,
                'arguments': {
                    **args
                }
            })
        )

        resp_json = resp.json()
        if resp_json['result'] != 'success':
            logging.error('request failed with status: %s', resp_json['result'])
        resp.raise_for_status()
        return resp_json

    @property
    def link(self):
        """URL like link for the transmission host"""
        link = 'http://' + self.url
        if self.path:
            link = link + self.path
        return link

    @property
    def url(self):
        "host name portion of the transmission link"
        return self.host + ':' + str(self.port)

    @staticmethod
    def _socket_active(host, port):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            try:
                s.connect((host, port))
                return True
            except: # pylint: disable=W0702
                return False
