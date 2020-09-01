"""
A simple struct holding data related to my watcher config.

I found I kept repeating the same few lines of code in a bunch
of places while putting everything together, this file abstracts
that out to make things easier.
"""

import pathlib as p

class WatchConfig(object):
    def __init__(self, cfg: dict):
        self.torrents = p.Path(cfg['torrents-dir']).expanduser()
        self.added    = self.torrents / cfg['added-subdir']

        self.added.mkdir(parents=True, exist_ok=True)

        self.rules = cfg['rules']
        assert len(self.rules) > 0, 'must supply at least one rule'
