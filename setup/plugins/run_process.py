import os
import subprocess

def run_process(cmd, options, process_kwargs=None):
    if process_kwargs is None:
        process_kwargs = {}

    with open(os.devnull, 'w+') as null:
        return subprocess.call(
            cmd,
            stdout = None if options['stdout'] else null,
            stderr = None if options['stderr'] else null,
            stdin  = None if options['stdin']  else null,
            **process_kwargs
        )
