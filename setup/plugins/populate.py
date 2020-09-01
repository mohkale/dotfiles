import os
import sys
import dotbot

sys.path.insert(0, os.path.dirname(__file__))
from log_mixin import LogMixin

class PopulatePlugin(LogMixin, dotbot.Plugin):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def can_handle(self, action):
        return action == 'populate'

    def handle(self, action, data):
        if not self.can_handle(action):
            raise ArgumentError("%s can't handle action: %s" % (self.__class__.__name__, action))

        if isinstance(data, dict):
            data = [data]

        result = True
        for spec in data:
            default = self.default_data
            default.update(spec)

            result &= self._handle(default)
        return result

    def _handle(self, spec):
        if 'path' not in spec or 'body' not in spec:
            self.error('must supply both a path and body.')
            return False

        path = os.path.expanduser(spec['path'])
        container = os.path.dirname(path)
        if not os.path.exists(container):
            if not spec['create']:
                self.error("parent directory for path '%s' doesn't exist" % path)
                return False
            os.makedirs(container)

        self.lowinfo('populating file: ' + spec['path'])
        try:
            with open(path, spec['mode'], encoding='utf8') as fd:
                fd.write(spec['body'])

            return True
        except Exception as e:
            self.error(e)
            return False

    @property
    def default_data(self):
        default = {
            'mode': 'w',
            'create': False,
        }
        default.update(self._context.defaults().get('populate', {}))
        return default
