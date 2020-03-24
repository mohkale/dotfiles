"""
Support modular dotbot configurations.

This plugin allows you to nest dotbot configurations into subdirectories,
allowing you to toggle execution of a config depending on the DOTBOTS
environment variable (which should a CSV seperated list). The special value
of all in DOTBOTS, will force execution of every subconfig.

The format accepted by this plugin in your config.yaml file is:

  - bots
      - foo
      - path:   bar
        env:    bar
        cache:  true
        unsafe: false
        config: baz.yaml

The env option specifies that this subbot should only be invoked when the given
value is found in the DOTBOTS environement variable. You can set it to a boolean
to have it check the same string as the basename of path. It defaults to false.

The cache option specifies that if during evaluation, multiple calls to the same
bot config is found, don't invoke it more than once. This is useful if, for example,
you're installing vim and nvim, where nvim also requires vim to be setup. This
defaults to true.

By default the path value has to be relative and not resolve to a directory higher
up then the cwd. This forces a modular structure, but in some cases you may want
to reference external configs. In this case, you can set unsafe to false and no
checking on the path will take place.

The config variable specifies the filename of the config file. This defaults to the
default used by dotbot.

Configs are searched for, in order of:
  - a file within the destination directory, with the filename matching the config
    file name.
  - a file in the same directory as the parent of the destination directory, with
    the same basename as the destination directory but with a .yml suffix.
  - the same as above, except within the destination directory instead of alongside
    it.
"""

import os
import io
import csv
import sys
import functools
from typing import Dict

import dotbot
from dotbot.dispatcher import Dispatcher
from dotbot.config import ConfigReader, ReadingError

sys.path.insert(0, os.path.dirname(__file__))
from log_mixin import LogMixin

class SubBotPlugin(LogMixin, dotbot.Plugin):
    def __init__(self, *args, **kwargs):
        # tasks that're passed down to sub bots.
        self.default_tasks = []

        super().__init__(*args, **kwargs)

    def can_handle(self, action):
        return action in ['bots', 'defaults']

    def handle(self, action, data):
        if not self.can_handle(action):
            raise ValueError(
                "%s can't handle action: %s" % (self.__class__.__name__, action))

        exit_status = True  # passed
        if action == 'defaults':
            self.default_tasks.append({action: data})
        else:
            # data has to be a list of spec values.
            if not isinstance(data, list): data = [data]

            for spec in data:
                if isinstance(spec, str):
                    spec = {'path': spec}

                if not isinstance(spec, dict):
                    self.error('specs must be a dict or str, not ' + spec.__class__.__name__)
                else:
                    self.info('invoking subbot %s (from %s)' % (
                        spec.get('path', ''), self._context.base_directory()))

                    spec = self._populate_spec(spec, self._context.defaults())
                    if 'path' not in spec:
                        self.error('specs must supply a path argument')
                        return False
                    else:
                        exit_status &= self._process(spec)
        return exit_status

    def _process(self, spec: Dict[str, str]):
        """process a well formed subbot spec."""
        if 'path' not in spec:
            self.error('specs must supply a path argument')
            return False

        if self._is_unsafe(spec, log=self):
            return False  # ensure spec is safe to use.

        path = os.path.realpath(
            os.path.join(self._context.base_directory(True), spec['path']))

        if spec['env']:
            if not isinstance(spec['env'], str):
                spec['env'] = os.path.basename(path.rstrip('/'))

            if spec['env'] and not self.allowed_bot(spec['env']):
                self.warn('subbot %s skipped because of DOTBOTS' % spec['env'])
                return True

        config = self.get_config(spec, path, log=self)

        if not config: return False
        if path in self._cached_subbots:
            return True

        if spec['cache']:
            self._cached_subbots.append(path)
        return self._invoke_subbot(spec, path, config)

    def _read_tasks(self, spec, config):
        tasks = ConfigReader(config).get_config()
        if not isinstance(tasks, list):
            raise ReadingError('Configuration file must be a list of tasks')
        tasks = spec.get('tasks', []) + tasks
        tasks = self.default_tasks + tasks
        return tasks

    def _invoke_subbot(self, spec, path: str, config: str) -> bool:
        """start a subot at PATH using CONFIG."""
        cwd = os.getcwd()
        try:
            os.chdir(path)
            tasks = self._read_tasks(spec, config)
            return Dispatcher(path).dispatch(tasks)
        except Exception as e:
            self.error(e)
            return False
        finally:
            os.chdir(cwd)

    @staticmethod
    def _is_unsafe(spec, log=None):
        """whether a given spec is safe to use."""
        if not spec['unsafe']:
            path = spec['path']

            # check path doesn't resolve to somewhere above current directory
            if os.path.isabs(path) or path.startswith('../'):
                log and log.error('spec cannot have absolute or relative paths in unsafe mode.')
                return True
            if os.path.dirname(spec['config']) != '':
                log and log.error('config name for subbots must be a single filename in safe mode.')
                return True

        return False

    @staticmethod
    def get_config(spec, path, log=None):
        """get the first existing config file matching PATH from the cwd."""
        configs = [
            os.path.realpath(os.path.join(path, spec['config'])),
            os.path.realpath(path.rstrip('/') + '.yml'),
            os.path.realpath(os.path.join(path, os.path.basename(path.rstrip('/')) + '.yml')),
        ]
        for p in configs:
            if os.path.exists(p) and os.path.isfile(p):
                return p

        log and log.error('subbot config not found: ' + configs[0])

    def allowed_bot(self, bot: str):
        if 'all' in self.dotbots:
            return True

        return bot.lower() in self.dotbots

    @property
    @functools.lru_cache()
    def dotbots(self) -> [str]:
        dotbots = os.getenv('DOTBOTS')
        if dotbots is None:
            return []  # no bots setup
        else:
            bots = []
            for row in csv.reader(io.StringIO(dotbots)):
                bots.extend(row)
            for bot in bots:
                self.debug('discovered allowed subot: ' + bot)
            return bots

    @staticmethod
    def _spec_defaults(ctx_defaults):
        """get a dictionary containing default options for a spec."""
        default = {
            'cache':  True,
            'unsafe': False,
            'env': False,
            'config': 'install.conf.yaml',
        }
        if ctx_defaults:
            default.update(ctx_defaults.get('bots', {}))
        return default

    @classmethod
    def _populate_spec(cls, new_spec, ctx_defaults=None):
        """given a spec SPEC, populate any ommited defaults."""
        spec = cls._spec_defaults(ctx_defaults)
        spec.update(new_spec)

        return spec

    _cached_subbots = []
