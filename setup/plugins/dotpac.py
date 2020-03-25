"""
The universal package manager for dotbot.

I saw a lot of small plugins adding features for different package managers,
but this seemed like a situation which called for a single directive, ergo
this plugin :).

The format accepted by this plugin in your config.yaml file is:

  - package:
      - pip:
          - spec-1
          - spec-2
      - yay:
          - spec-1
          - spec-2

Every spec must supply a package field, and optionally has stdin, stdout and
stderr. There's also an interactive field which determines the defaults of the
stdin, stdout and stderr fields.

Each package manager defines it's own spec (found below). The package plugin
iterates through the specified managers until one which exists is found, then
all the specs for the specified manager are evaluated.

NOTE: you can pass the package managers as a hash, instead of an array of hases
      but this will have undefined behaviour in earlier python versions. do so
      at your own risk :P.
"""

import os
import sys
import enum
import dotbot
import functools

from typing import Union, List

from distutils.spawn import find_executable

from abc import ABC as AbstractClass
from abc import abstractmethod, abstractclassmethod

from dotbot.messenger import Level

sys.path.insert(0, os.path.dirname(__file__))
from run_process import run_process
from log_mixin import LogMixin

class PackageStatus(enum.Enum):
    # These names will be displayed
    UP_TO_DATE = 'Up to date'
    INSTALLED  = 'Installed'
    NOT_FOUND  = 'Not Found'
    ERROR      = "Build Error"
    NOT_SURE   = 'Could not determine'


class DotbotPackageManager(AbstractClass):
    """
    Root class for a package manager specification.

    This class configures the interface for a specific package management
    program (eg. pacman).

    Methods
    -------
    install
      install a package using the package manager.

    Fields
    ------
    name
      the name of the package manager, used to match directives in config.yml.

    display-name
      the name shown for this package manager in dotbot logs.

    filenames
      the name of, or a list of aliases for, the executable tied to this
      package manager.

    updated
      whether or not the package database for the current package manager
      is assumed to be up to date or not.
    """
    name: str = None # used to match directive
    display_name: str = None # what's shown in output logs
    filenames: Union[str, List[str]] = None

    _executable: str = None  # path to found bin
    updated: bool = False
    _exists: bool = None # don't know yet

    process_kwargs = {
        'shell': True
    }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def _run_process(self, *args, **kwargs):
        process_kwargs = kwargs.pop('process_kwargs', {})
        for key, val in self.process_kwargs.items():
            process_kwargs.setdefault(key, val)
        return run_process(*args, process_kwargs=process_kwargs, **kwargs)

    @classmethod
    def _update(cls):
        if not cls.updated:
            cls.update()
            cls.updated = True

    @abstractmethod
    def install(self, spec, log=None):
        pass

    @classmethod
    @abstractclassmethod
    def update(cls):
        pass

    def populate_spec(self, spec, cwd, defaults):
        if isinstance(spec, str):
            spec = {'package': spec}
        return spec

    def _log_installing(self, log, package_name):
        log and log.info(f'installing {self.name} package [{package_name}]')

    # the status output of a given package
    def status(self, pkg: str) -> PackageStatus:
        return PackageStatus.NOT_SURE

    def fail_if_not_exists(self):
        if not self.exists:
            raise RuntimeError(
                'cannot run package manager %s with non-existant binary' %
                self.__class__.__name__)

    @classmethod
    def executable(cls, log=None):
        if cls._executable is None:
            execs = cls.filenames
            if isinstance(execs, str):
                execs = [execs]
            elif not isinstance(execs, list):
                raise ValueError(
                    '%s.filenames should be a string or list of strings, not: %s' %
                    (cls.__name__, type(cls.filenames).__name__))

            for alias in execs:
                file = find_executable(alias)
                if file is not None:
                    cls._executable = file
                    break

        return cls._executable

    @classmethod
    def matches(cls, name):
        return name == cls.name

    @classmethod
    def exists(cls, log=None):
        """Whether or not the binary for this package manager exists."""
        if cls._exists is None:
            cls._exists = cls.executable(log=log) is not None

        return cls._exists


def _leaf_subclasses(cls, collection=None):
    """In the tree of subclasses for CLS, return an array of all subclasses
    which have no subclasses themselves (I.E. the leaf level subclasses for
    CLS)."""
    if collection is None: collection = set()

    subclasses = cls.__subclasses__()

    if len(subclasses) == 0:
        collection.add(cls)
    else:
        for subcls in subclasses:
            _leaf_subclasses(subcls, collection)

    return list(collection)


#  ____  _             _
# |  _ \| |_   _  __ _(_)_ __
# | |_) | | | | |/ _` | | '_ \
# |  __/| | |_| | (_| | | | | |
# |_|   |_|\__,_|\__, |_|_| |_|
#                |___/

class DotbotPackagePlugin(LogMixin, dotbot.Plugin):
    def can_handle(self, action):
        return action in ['package', 'packages', 'defaults']

    def handle(self, action, data):
        if not self.can_handle(action):
            raise ValueError(
                "%s can't handle action: %s" % (self.__class__.__name__, action))

        if action == 'defaults':
            return True
        else: # action == 'package':
            if isinstance(data, dict):
                data = [{key: value} for key, value in data.items()]
            elif not isinstance(data, list):
                self.error('data for package must be hash or list, not: ' + type(data).__name__)
                return False

            found = self.find_package_manager(data)
            if found:
                pacman, packages = found  # unpack
                pacman._update()

                ret = True
                for package in packages:
                    package = pacman.populate_spec(
                        package, self.cwd, self._context.defaults())
                    if self._log._level <= Level.DEBUG:
                        package['verbose'] = True
                    res = pacman.install(package, log=self)
                    ret &= res

                    if not res:
                        self.error('failed to install package')
                return ret
            else:
                return False

    def find_package_manager(self, data):
        tried_pacmans = []
        for _ in data:  # package hash in data list
            for pacman, packages in _.items():
                tried_pacmans.append(pacman)
                for package_manager in self.package_managers():
                    if package_manager.matches(pacman) and \
                       package_manager.exists(log=self):
                        return package_manager, packages

        self.error('failed to find package managers, tried: ' + ', '.join(tried_pacmans))

    @property
    def cwd(self):
        return self._context.base_directory()

    _package_managers = None

    @classmethod
    def package_managers(cls):
        """get a list of all the leaf level Package Manager instances.
        The idea here is you construct all package manager subclasses
        before you invoke this method, once you do, the package managers
        will be cached by constructing new instances of them and binding
        those instances to the DotbotPackagePlugin class.

        We choose leaf level derivations of DotbotPackageManager, because
        that way deriving a package manager overrides it's parent. If you
        want a pipx package manager, you're gonna have to replace the pip
        and manager, or construct a new class, or have both pip and pipx
        share from a common parent class.
        """
        if cls._package_managers is None:
            cls._package_managers = [x() for x in _leaf_subclasses(DotbotPackageManager)]
        return cls._package_managers


#  ____            _                      __  __
# |  _ \ __ _  ___| | ____ _  __ _  ___  |  \/  | __ _ _ __   __ _  __ _  ___ _ __ ___
# | |_) / _` |/ __| |/ / _` |/ _` |/ _ \ | |\/| |/ _` | '_ \ / _` |/ _` |/ _ \ '__/ __|
# |  __/ (_| | (__|   < (_| | (_| |  __/ | |  | | (_| | | | | (_| | (_| |  __/ |  \__ \
# |_|   \__,_|\___|_|\_\__,_|\__, |\___| |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_|  |___/
#                            |___/                                 |___/

class PipPackageManager(DotbotPackageManager):
    """Package manager for the python pip module system.
    See also https://github.com/sobolevn/dotbot-pip

    Spec format

      package: package-name
      user: false
    """
    name = 'pip'
    filenames = 'pip'

    def install(self, spec, log=None):
        self.fail_if_not_exists()

        cmd = [self.executable(log=self), 'install']
        if spec['user']:
            cmd += ['--user']
        cmd += [spec['package']]
        self._log_installing(log, spec['package'])
        return self._run_process(cmd, spec) == 0

    # pip doesn't have a database of available packages. it get's data on
    # the packages it wants, when it wants them.
    @classmethod
    def update(cls): pass

    def populate_spec(self, spec, cwd, defaults):
        spec = super().populate_spec(spec, cwd, defaults)
        spec.setdefault('user', False)
        return spec

class GoPackageManager(DotbotPackageManager):
    """Package manager for golangs module system.
    See also https://github.com/delicb/dotbot-golang

    Spec format

      package: package-name
    """
    name = 'go'
    filenames = 'go'

    def install(self, spec, log=None):
        self.fail_if_not_exists()

        cmd = [self.executable(log=self), 'get', spec['package']]
        self._log_installing(log, spec['package'])
        return self._run_process(cmd, spec) == 0

    @classmethod
    def update(cls): pass

# class PacmanPackageManager(DotbotPackageManager):
#     pass

# class YayPackageManager(DotbotPackageManager):
#     pass

# class AptPackageManager(DotbotPackageManager):
#     pass

