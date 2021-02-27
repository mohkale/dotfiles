# -*- mode: python -*- ipython_config.py -- ipython [[config][https://ipython.readthedocs.io/en/stable/config/options/terminal.html]] file

c.AliasManager.user_aliases = [
 ('l', 'ls'),
 ('cls', 'clear'),
 ('la', 'ls -a'),
 # TODO: Load aliases from ~/.config/aliases
]

c.InteractiveShellApp.exec_PYTHONSTARTUP = True                                # Keep PYTHONSTARTUP configurations
c.InteractiveShellApp.ignore_cwd = False                                       # Allow importing files from the cwd
c.BaseIPythonApplication.profile = 'default'
c.TerminalIPythonApp.display_banner = False
# c.InteractiveShell.colors = 'Linux'
c.InteractiveShell.history_length = 1_000_000
c.InteractiveShell.history_load_length = 1_000
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.display_completions = 'multicolumn'

c.TerminalInteractiveShell.editing_mode = 'emacs'
# c.TerminalInteractiveShell.editor = 'nvim'
c.TerminalInteractiveShell.extra_open_editor_shortcuts = True
c.TerminalInteractiveShell.highlight_matching_brackets = True
