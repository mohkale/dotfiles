"""Helper methods to load logging configurations from the filesystem."""

import enum
import functools
import itertools
import json
import os
import pathlib
import typing
import logging.config

try:
    import yaml
    YAML_AVAILABLE = True
except ImportError:
    YAML_AVAILABLE = False

from mohkale.utils import merge_dict

def _load_yaml(stream):
    if not YAML_AVAILABLE:
        raise ValueError('Yaml configuration files require pyyaml to be installed')
    return yaml.load(stream, Loader=yaml.CLoader)

class ConfigExtensions(enum.Enum):
    """The kind of file types we support loading configs from.

    Should be a mapping from file extensions to functions that
    can load those file extensions.

    The filenames will be checked by lowercasing the extension
    and appending it to the filename we expect to find.
    """

    JSON = functools.partial(json.load)
    YAML = functools.partial(_load_yaml)
    YML = functools.partial(_load_yaml)


LOGGING_CONFIG_DIR = pathlib.Path(os.environ.get('XDG_CONFIG_HOME', '~/.config')).expanduser() / 'pylog'

def load_config(script: typing.Optional[str], default=dict()):
    """Load a logging configuration file from the filesystem.

    Config files are looked for in my global logging config directory
    (see: [[https://fangpenlin.com/posts/2012/08/26/good-logging-practice-in-python/#use-json-or-yaml-logging-configuration][here]]).

    By default this function loads the default config and then merges it
    into the scripts config. If neither of these configurations are
    available we return the value of the `default` argument.

    By default we try to load a config matching the script parameter and
    if not available we try a default configuration. If neither of these
    is found the value of `default` is returned.

    Parameters
    ----------
    script
      Name of the current script/program that's being sourced. This is used
      to find the specific configuration being sourced. Set to None to only
      load the default config.
    default
      What to return when no configuration exists in any of the config
      directories.

    """
    loaded = False
    config = {}

    # Default is the one on my dotfiles, local is host specific.
    it = ['default', 'default.local']
    if script:
        it = itertools.chain(it, [script])
    for basename in it:
        for ext in ConfigExtensions:
            path = LOGGING_CONFIG_DIR / f'{basename}.{ext.name.lower()}'
            if not path.exists():
                continue
            with open(path, 'r') as fd:
                config = merge_dict(ext.value(fd), config)
            loaded = True
            break
    return config if loaded else default

def use_config(script, default={}, **kwargs):
    """Proxy for `load_config` that also uses the config."""
    conf = load_config(script, default)
    if conf:
        logging.config.dictConfig(conf)

        # Apply any level aliases from the configuration.
        for name, level in conf.get('levels', {}).items():
            if level is not int:
                level = getattr(logging, level, None)
                if level is None:
                    continue
            logging.addLevelName(level, name)
    if 'level' in kwargs and kwargs['level'] is not None:
        logging.getLogger().handlers[0].setLevel(kwargs['level'])
    return conf
