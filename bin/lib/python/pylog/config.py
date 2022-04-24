"""Helper methods to load logging configurations from the filesystem."""

import enum
import functools
import itertools
import json
import os
import io
import sys
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
    return yaml.load(stream, Loader=yaml.SafeLoader)

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

def load_config(script: typing.Optional[str], default=None):
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
    default = default or None

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

def use_config(script, default=None, level=None,
               log_file=None, overwrite_std_with_log_file=False,
               **_kwargs):
    """Proxy for `load_config` that also uses the config.

    Parameters
    ----------
    level : int
      Overwrite the level of each setup handler with `level`.
    log_file : Optional[Union[io.TextIOWrapper, str]]
      Attach a new handler to write to `log_file`.
    overwrite_std_with_log_file : bool
      When true and about to add log_file to handlers, remove
      any existing handlers which would write to stdout/stderr.
    """
    conf = load_config(script, default)
    if conf:
        logging.config.dictConfig(conf)

        # Apply any level aliases from the configuration.
        for name, lvl in conf.get('levels', {}).items():
            if lvl is not int:
                lvl = getattr(logging, lvl, None)
                if lvl is None:
                    continue
            logging.addLevelName(lvl, name)
    logging._defaultFormatter = logging.Formatter(
        conf.get('default_format', logging._defaultFormatter._fmt),
        conf.get('default_datefmt', logging._defaultFormatter.datefmt),
    )
    if log_file is not None:
        if isinstance(log_file, io.TextIOWrapper):
            logging.StreamHandler(log_file)
        else:
            handler = logging.FileHandler(log_file, 'a', encoding='utf-8')
        if overwrite_std_with_log_file:
            logging.getLogger().handlers = \
                [h for h in logging.getLogger().handlers if
                 isinstance(handler, logging.StreamHandler)
                 and handler.stream in (sys.stdout, sys.stderr)]
        logging.getLogger().addHandler(handler)
    if level is not None:
        # You override the level of all the root-level handlers
        # if you pass one to use_config, including file handlers.
        for handler in logging.getLogger().handlers:
            handler.setLevel(level)
    return conf
