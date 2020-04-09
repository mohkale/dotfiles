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
        when:
          - command: [ -f foo ]
            interactive: false
            stdout: true
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
import copy
import functools
from typing import Dict

import dotbot
from dotbot.dispatcher import Dispatcher
from dotbot.config import ConfigReader, ReadingError

sys.path.insert(0, os.path.dirname(__file__))
from run_process import run_process
from log_mixin import LogMixin

def create_dispatcher(path, context):
    """create a new dispatcher, cloning the context of an existing one."""
    dispatcher = Dispatcher(path)
    dispatcher._context.set_defaults(copy.deepcopy(context.defaults()))
    return dispatcher

class SubBotPlugin(LogMixin, dotbot.Plugin):
    def can_handle(self, action):
        return action in 'bots'

    def handle(self, action, data):
        if not self.can_handle(action):
            raise ValueError(
                "%s can't handle action: %s" % (self.__class__.__name__, action))

        exit_status = True  # passed
        # data has to be a list of spec values.
        if not isinstance(data, list): data = [data]

        for spec in data:
            if isinstance(spec, str):
                spec = {'path': spec}

            if not isinstance(spec, dict):
                self.error('specs must be a dict or str, not ' + spec.__class__.__name__)
            else:
                spec = self._populate_spec(spec, self._context.defaults())
                if 'path' not in spec:
                    self.error('specs must supply a path argument')
                    exit_status = False
                else:
                    exit_status &= self._process(spec)
        return exit_status

    def _name_from_spec(self, spec, path, config):
        if spec['config'] == os.path.basename(config):
            name = os.path.basename(path)
        else:
            path = os.path.dirname(config)
            name = os.path.splitext(os.path.basename(config))[0]
        return path, name

    def _process(self, spec: Dict[str, str]):
        """process a well formed subbot spec."""
        if 'path' not in spec:
            self.error('specs must supply a path argument')
            return False

        if self._is_unsafe(spec, log=self):
            return False  # ensure spec is safe to use.

        path = os.path.realpath(
            os.path.join(self._context.base_directory(True), spec['path']))

        config = self.get_config(spec, path, log=self)

        if not config: return False
        if path in self._cached_subbots:
            return True

        path, name = self._name_from_spec(spec, path, config)

        if spec['env']:
            if not isinstance(spec['env'], list):
                spec['env'] = [spec['env']]

            allowed = False
            for env in spec['env']:
                if not isinstance(env, str):
                    env = name

                if self.allowed_bot(env):
                    allowed = True
                    break
            if not allowed:
                self.warn('subbot %s skipped because of DOTBOTS' % name)
                return True

        shell = os.getenv('SHELL') or 'sh'
        for test in spec['if']:
            if isinstance(test, str):
                test = {'command': test}
            if run_process([shell, '-c', test['command']], test) != 0:
                self.debug('skipping subbot %s because test `%s` failed' %
                             (name, '; '.join(test['command'].split('\n'))))
                return True
        if spec['cache']:
            self._cached_subbots.append(path)

        self.info('invoking subbot %s (from %s)' % (name, path))

        return self._invoke_subbot(spec, path, config)

    def _read_tasks(self, spec, config):
        tasks = ConfigReader(config).get_config()
        if not isinstance(tasks, list):
            raise ReadingError('Configuration file must be a list of tasks')
        tasks = spec.get('tasks', []) + tasks
        return tasks

    def _invoke_subbot(self, spec, path: str, config: str) -> bool:
        """start a subot at PATH using CONFIG."""
        cwd = os.getcwd()
        try:
            os.chdir(path)
            tasks = self._read_tasks(spec, config)
            return create_dispatcher(path, self._context).dispatch(tasks)
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

    _dotbots = None

    @property
    @functools.lru_cache()
    def dotbots(self) -> [str]:
        cls = type(self)
        if cls._dotbots is None:
            dotbots = os.getenv('DOTBOTS')
            if dotbots is None:
                cls._dotbots = []  # no bots setup
            else:
                bots = []
                for row in csv.reader(io.StringIO(dotbots)):
                    bots.extend(row)
                for bot in bots:
                    self.debug('discovered allowed subot: ' + bot)
                    cls._dotbots = bots

        return cls._dotbots

    @classmethod
    def _populate_spec(cls, spec, ctx_defaults=None):
        """given a spec SPEC, populate any ommited defaults."""
        for key, val in ctx_defaults.get('bots', {}).items():
            spec.setdefault(key, val)

        spec.setdefault('cache', True)
        spec.setdefault('unsafe', False)
        spec.setdefault('env', False)
        spec.setdefault('config', 'install.conf.yaml')
        spec.setdefault('if', [])

        if not isinstance(spec['if'], list):
            spec['if'] = [spec['if']]

        if 'when' in spec:
            when = spec.pop('when')
            if not isinstance(when, list):
                when = [when]
            spec['if'] += when

        if 'path' in spec:
            spec['path'] = spec['path'].rstrip('/')

        return spec

    _cached_subbots = []
