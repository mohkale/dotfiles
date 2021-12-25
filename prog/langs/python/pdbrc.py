# -*- mode: python -*-
"""
Loaded by ~/.pdbrc, because .pdbrc can only contain pdb commands.
"""

# Command line history.
import atexit
import os
import readline

histfile = (
    os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.cache")) + "/pdb_history"
)
try:
    readline.read_history_file(histfile)
except IOError:
    pass

atexit.register(readline.write_history_file, histfile)
del histfile
readline.set_history_length(500)

# Cleanup any variables that could otherwise clutter up the namespace.
del atexit, os, readline
