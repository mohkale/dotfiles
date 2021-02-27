"""Basic facilities for concurrent file downloading in python.

This module is designed to deprecate [[https://github.com/mohkale/DownloadQueue][mohkale/DownloadQueue]].
"""

import os
import io
import re
import time
import logging
import requests
import typing as t
import collections
from multiprocessing.pool import ThreadPool

DEFAULT_FNAME_COUNTER = collections.Counter()

DEFAULT_HEADERS = {
    # You almost always don't want who your downloading from to think you're a bot.
    # If you disagree, pass headers={'User-Agent': None}
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 \
(KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36',
}

_DOWNLOAD_CALLBACK_T = t.Callable[[str, t.Optional[Exception]], None]

def _download(url, dest, args, kwargs):
    callback: t.Optional[_DOWNLOAD_CALLBACK_T] = kwargs.pop('callback', None)
    chunk_size: int = kwargs.pop('chunk_size', 2 ** 10)  # default=1MB
    check_status: bool = kwargs.pop('check_status', True)
    attempt_count: int = max(1, kwargs.pop('attempt_count', 10))
    attempt_delay: int = max(0, kwargs.pop('attempt_delay', 3))
    req_method = kwargs.pop('req_method', requests.get)
    headers = DEFAULT_HEADERS.copy()
    headers.update(kwargs.get('headers', {}))
    kwargs['headers'] = headers

    buf, complete = io.BytesIO(), False
    try:
        for i in range(attempt_count):
            # Download the entirety of the request into memory first.
            if complete:
                # Already copied all of URL into memory but a previous write attempt
                # crashed while saving to disk so try to write again without refetching.
                buf.seek(0)
            else:
                try:
                    req = req_method(url, *args, **kwargs, stream=True)
                    if check_status:
                        req.raise_for_status()
                    for chunk in req.iter_content(chunk_size):
                        if chunk:
                            buf.write(chunk)
                    complete = True
                except KeyboardInterrupt: raise
                except:
                    if i == attempt_count - 1:
                        raise
                    logging.error('Failed to retrieve URL with attempt %d: %s', i + 1, url)
                    time.sleep(attempt_delay)
                    continue
                finally: buf.seek(0)

            # Now write it back out to the filesystem destination.
            if isinstance(dest, str):
                dest = open(dest, 'wb')
            else:
                dest.seek(0)
            dest.write(buf.read())
            break
    except (KeyboardInterrupt, Exception) as e:
        logging.exception('Failed to download url: %s', url)
        if callback:
            callback(url, e)
    else:
        if callback:
            callback(url, None)
    finally:
        if hasattr(dest, 'close'):
            dest.close()


class DownloadPool(object):
    """Wrapper around ThreadPool designed to be used to download files."""

    def __init__(self, sz: int):
        logging.debug('Initialised download pool with size %d', sz)
        self.pool = ThreadPool(sz)

    def __enter__(self):
        # self.pool.start()
        return self

    def __exit__(self, type, value, traceback):
        self.pool.close()
        self.pool.join()

    def add(self, urls: t.Union[str, t.List[str], t.List[t.Tuple[str, str]]], *args, **kwargs):
        """Add some files to be downloaded to the download pool.

        Add one or more URLs for the thread pool to try and download when resources
        are availabe.

        Parameters
        ----------
        urls
          A url, collection of urls or collection of tupes of urls and their
          destinations paths. The final form is the recommended format for urls.
        args
          Extra arguments passed to _download.
        kwargs
          Extra keyword arguments passed to_download.

        """
        if isinstance(urls, str):
            urls = [urls]
            # Generate a collection of parameters to be sent to `download'
        it = ((url if isinstance(url, str) else url[0],
               self._default_dest(url) if isinstance(url, str) else url[1],
               args, kwargs) for url in urls)
        return self.pool.starmap_async(_download, it)

    @staticmethod
    def _default_dest(url):
        basename = re.sub(r'(\?|#).+$', '', os.path.split(url)[1])
        if basename == '':
            DEFAULT_FNAME_COUNTER[url] += 1
            basename = f'file-{DEFAULT_FNAME_COUNTER[url]}'
        return basename
