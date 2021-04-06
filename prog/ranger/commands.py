"""
Ranger command configuration file.
"""

import re
import os
import subprocess

from ranger.api.commands import Command

class mkcd(Command):
    """
    :mkcd <dirname>

    Source [[https://github.com/ranger/ranger/wiki/Custom-Commands#mkcd-mkdir--cd][here]].
    Creates a directory with the name <dirname> and enters it.
    """
    def execute(self):
        dirname = os.path.join(self.fm.thisdir.path, os.path.expanduser(self.rest(1)))
        if not os.path.lexists(dirname):
            os.makedirs(dirname)

            match = re.search('^/|^~[^/]*/', dirname)
            if match:
                self.fm.cd(match.group(0))
                dirname = dirname[match.end(0):]

            for m in re.finditer('[^/]+', dirname):
                s = m.group(0)
                if s == '..' or (s.startswith('.') and not self.fm.settings['show_hidden']):
                    self.fm.cd(s)
                else:
                    # We force ranger to load content before calling `scout`.
                    self.fm.thisdir.load_content(schedule=False)
                    self.fm.execute_console('scout -ae ^{}$'.format(s))
        else:
            self.fm.notify("file/directory exists!", bad=True)

class toggle_flat(Command):
    """
    :toggle_flat

    Source [[https://github.com/ranger/ranger/wiki/Custom-Commands#toggle-flat][here]].
    Flattens or unflattens the directory view.
    """
    def execute(self):
        if self.fm.thisdir.flat == 0:
            self.fm.thisdir.unload()
            self.fm.thisdir.flat = -1
            self.fm.thisdir.load_content()
        else:
            self.fm.thisdir.unload()
            self.fm.thisdir.flat = 0
            self.fm.thisdir.load_content()

class fzf(Command):
    """
    :fzf

    original Source [[https://github.com/ranger/ranger/wiki/Custom-Commands#fzf-integration][here]].

    Find a file (or directory) using fzf.

    With a prefix argument, ARG, don't search in directories
    below ARG levels.

    See: https://github.com/junegunn/fzf
    """
    dirs_only = False

    @property
    def find_cmd(self):
        """Return a command line to list files recursively.
        """
        query_flags = '-mindepth 1'

        if self.dirs_only:
            query_flags += ' -type d'
        if self.quantifier:
            query_flags += f' -maxdepth {self.quantifier}'

        cmd = fr"find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
        -o \( {query_flags} -print \) 2>/dev/null"

        return cmd

    def execute(self):
        command = '%s | fzf --no-multi' % self.find_cmd
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _stderr = fzf.communicate()

        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)

class fzf_cd(fzf):
    """
    :fzf_cd

    same as :fzf, except only searches for directories.

    See: :fzf
    """
    dirs_only = True
