import os
import shlex
import shutil
import subprocess

def run_process(cmd, options, process_kwargs=None):
    if process_kwargs is None:
        process_kwargs = {}

    interactive = options.get(
        'interactive',
        options.get('verbose', False))

    stdout = options.get('stdout', interactive)
    stderr = options.get('stderr', interactive)
    stdin  = options.get('stdin',  interactive)

    with open(os.devnull, 'w+') as null:
        res = subprocess.call(
            cmd,
            stdout = None if stdout else null,
            stderr = None if stderr else null,
            stdin  = None if stdin  else null,
            **process_kwargs
        )

        return res
