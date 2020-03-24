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
from run_process import run_process
from log_mixin import LogMixin

class ShellCommandMixin(LogMixin, object):
    action_name = 'shell-command-mixin'
    popen_kwargs = {}

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def can_handle(self, action):
        return action == self.action_name

    def msg_spec(self, spec):
        quiet = spec['quiet']
        msg = spec.get('msg', None)

        if msg is None:
            self.lowinfo(spec['command'])
        elif quiet:
            self.lowinfo('%s' % msg)
        else:
            self.lowinfo('%s [%s]' % (msg, spec['command']))


    def handle(self, action, data):
        if not self.can_handle(action):
            raise ValueError(
                self.action_name + ' cannot handle action ' + action)

        shell = os.environ.get('SHELL')
        success = True
        for spec in data:
            spec = self._populate_spec(spec)

            if 'command' not in spec:
                self.error('must specify command for shell.')
                success = False
                continue

            self.msg_spec(spec)
            cmd = spec['command']

            ret = run_process(
                self._format_command(shell, cmd),
                options=spec,
                process_kwargs={
                    'cwd': self._context.base_directory(),
                    'executable': shell,
                    **self.popen_kwargs
                }
            )
            if ret != 0:
                success = False
                self.warn('Command [%s] failed' % cmd)
        return success

    def _format_command(shell, cmd):
        raise NotImplementedError()

    def _populate_spec(self, spec):
        if isinstance(spec, list):
            spec = {'command': spec[0],
                    'description': spec[1]}
        elif not isinstance(spec, dict):
            spec = {'command': spec}

        spec.setdefault('stdin', False)
        spec.setdefault('stdout', False)
        spec.setdefault('stderr', False)
        spec.setdefault('quiet', False)

        for key, val in self._context.defaults().get(self.action_name, {}).items():
            spec.setdefault(key, val)

        return spec

class Shell(ShellCommandMixin, dotbot.Plugin):
    action_name = 'shell'

    @staticmethod
    def _format_command(shell, cmd):
        return [shell or 'sh', '-c', cmd]

class Command(ShellCommandMixin, dotbot.Plugin):
    action_name = 'command'

    @staticmethod
    def _format_command(shell, cmd):
        return cmd

# delete the existing shell plugin :P
dotbot.plugins.shell.Shell.__bases__ = (type("OtherClass", (object, ), {}), )
