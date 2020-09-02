import os
import subprocess
from dotbot.plugins.link import Link

# see ./shell.py for why this is necessary.
def _test_success(self, command):
    shell = os.environ.get('SHELL')
    with open(os.devnull, 'w') as devnull:
        ret = subprocess.call(
            [shell, '-c', command],
            stdout=devnull,
            stderr=devnull,
            executable=shell)
    if ret != 0:
        self._log.debug('Test \'%s\' returned false' % command)
    return ret == 0

Link._test_success = _test_success
