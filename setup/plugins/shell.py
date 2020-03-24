"""
My reimplementation of the shell command plugin.

The default plugin had issues with git bash on windows, this reimplementation
get's around those issues by introducing two commands, Shell & Command, where
the former replaces the built in shell command.

Shell invokes a subprocess through [bash -c], whereas Command invokes the
process directly (through a subshell).
"""

import os
import sys
import dotbot
import subprocess

sys.path.insert(0, os.path.dirname(__file__))
from log_mixin import LogMixin

class ShellCommandMixin(LogMixin, object):
    action_name = 'shell-command-mixin'
    popen_kwargs = {}

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def can_handle(self, action):
        return action == self.action_name

    def handle(self, action, data):
        if not self.can_handle(action):
            raise ValueError(
                self.action_name + ' cannot handle action ' + action)

        success = True
        with open(os.devnull, 'w') as devnull:
            for spec in data:
                if isinstance(spec, list):
                    spec = {'command': spec[0],
                            'description': spec[1]}
                elif not isinstance(spec, dict):
                    spec = {'command': spec}

                spec = self._populate_spec(spec)

                if 'command' not in spec:
                    self.error('must specify command for shell.')
                    success = False
                    continue

                quiet = spec['quiet']
                cmd   = spec['command']
                msg   = spec.get('msg', None)
                stdin  = None if spec['stdin']  else devnull
                stderr = None if spec['stderr'] else devnull
                stdout = None if spec['stdout'] else devnull

                if msg is None:
                    self.lowinfo(cmd)
                elif quiet:
                    self.lowinfo('%s' % msg)
                else:
                    self.lowinfo('%s [%s]' % (msg, cmd))
                shell = os.environ.get('SHELL')
                ret = subprocess.call(
                    self._format_command(shell, cmd),
                    stdin=stdin, stdout=stdout, stderr=stderr,
                    cwd=self._context.base_directory(),
                    executable=shell, **self.popen_kwargs)
                if ret != 0:
                    success = False
                    self.warn('Command [%s] failed' % cmd)
        return success

    def _format_command(shell, cmd):
        raise NotImplementedError()

    def _populate_spec(self, spec):
        default = {
            'stdin': False,
            'stdout': False,
            'stderr': False,
            'quiet': False
        }
        default.update(self._context.defaults().get(self.action_name, {}))
        default.update(spec)
        return default

class Shell(ShellCommandMixin, dotbot.Plugin):
    action_name = 'shell'

    @staticmethod
    def _format_command(shell, cmd):
        return [shell, '-c', cmd]

class Command(ShellCommandMixin, dotbot.Plugin):
    action_name = 'command'

    @staticmethod
    def _format_command(shell, cmd):
        return cmd

# delete the existing shell plugin :P
dotbot.plugins.shell.Shell.__bases__ = (type("OtherClass", (object, ), {}), )
