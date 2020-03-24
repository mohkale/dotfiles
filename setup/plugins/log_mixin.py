class LogMixin(object):
    def debug(self, *args, **kwargs):
        self._log.debug(*args, **kwargs)

    def lowinfo(self, *args, **kwargs):
        self._log.lowinfo(*args, **kwargs)

    def info(self, *args, **kwargs):
        self._log.info(*args, **kwargs)

    def warn(self, *args, **kwargs):
        self._log.warning(*args, **kwargs)

    def warning(self, *args, **kwargs):
        self.warn(*args, **kwargs)

    def error(self, *args, **kwargs):
        self._log.error(*args, **kwargs)
