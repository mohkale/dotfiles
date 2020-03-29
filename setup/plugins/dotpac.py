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

Each spec can have the following default fields (unless overriden by a package
manager):

  - package: foo
    interactive: false
    stdin:  false
    stderr: false
    stdout: false
    before: echo "i'm about to install foo"
    after:  echo "it's done, yay!"

Every spec must supply a package field, and optionally has stdin, stdout and
stderr. There's also an interactive field which determines the defaults of the
stdin, stdout and stderr fields.

Each package manager defines it's own spec (found below). The package plugin
iterates through the specified managers until one which exists is found, then
all the specs for the specified manager are evaluated.

You can pass a skip_package environment variable to skip this plugin from
installing anything.

NOTE: you can pass the package managers as a hash, instead of an array of hases
      but this will have undefined behaviour in earlier python versions. do so
      at your own risk :P.
"""

import os
import sys
import enum
import dotbot
import shutil
import functools

from typing import Union, List

from distutils.spawn import find_executable

from abc import ABC as AbstractClass
from abc import abstractmethod, abstractclassmethod

from dotbot.messenger import Level

sys.path.insert(0, os.path.dirname(__file__))
from run_process import run_process
from log_mixin import LogMixin

# class PackageStatus(enum.Enum):
#     # These names will be displayed
#     UP_TO_DATE = 'Up to date'
#     INSTALLED  = 'Installed'
#     NOT_FOUND  = 'Not Found'
#     ERROR      = "Build Error"
#     NOT_SURE   = 'Could not determine'


class DotbotPackageManager(LogMixin, AbstractClass):
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

    filenames
      the name of, or a list of aliases for, the executable tied to this
      package manager.

    updated
      whether or not the package database for the current package manager
      is assumed to be up to date or not.
    """
    name: str = None # used to match directive
    filenames: Union[str, List[str]] = None

    updated: bool = False

    _executable: str = None  # path to found bin
    _exists: bool = None # don't know yet

    process_kwargs = {
        'shell': True
    }

    def __init__(self, *args, log, **kwargs):
        self._log = log
        super().__init__(*args, **kwargs)

    #region: stuff you're allowed to override
    @abstractmethod
    def install(self, spec):
        pass

    def update(self):
        """update managers package database."""
        pass

    def populate_spec(self, spec, cwd, defaults):
        if isinstance(spec, str):
            spec = {'package': spec}
        spec.setdefault('before', None)
        spec.setdefault('after', None)
        return spec
    #endregion

    @property
    def class_name(self):
        return type(self).__name__

    @classmethod
    def _run_process(cls, *args, **kwargs):
        process_kwargs = kwargs.pop('process_kwargs', {})
        for key, val in cls.process_kwargs.items():
            process_kwargs.setdefault(key, val)
        return run_process(*args, process_kwargs=process_kwargs, **kwargs)

    def sudo_validate(self):
        if os.name == 'nt':
            return True

        ret = self._run_process(
            'sudo --validate',
            options={'interactive': True},
            process_kwargs={'shell': True}) == 0

        if not ret:
            self.error('failed to gain root user privileges.')

        return ret

    def run_update(self):
        """runs update, unless this package managers already been updated."""
        if not type(self).updated:
            self.update()
            type(self).updated = True

    def _log_installing(self, package_name):
        self.info(f'installing {self.name} package [{package_name}]')

    # the status output of a given package
    # def status(self, pkg: str) -> PackageStatus:
    #     return PackageStatus.NOT_SURE

    def fail_if_not_exists(self):
        if not self.exists:
            raise RuntimeError(
                'cannot run package manager %s with non-existant binary' %
                self.class_name)

    @classmethod
    def matches(cls, name):
        """check whether the directive NAME matches this package manager"""
        return name == cls.name

    @property
    def exists(self):
        """Whether or not the binary for this package manager exists."""
        cls = type(self)

        if cls._exists is None:
            cls._exists = self.executable is not None

        return cls._exists

    @property
    def executable(self):
        cls = type(self)

        if cls._executable is None:
            execs = self.filenames
            if isinstance(execs, str):
                execs = [execs]
            elif not isinstance(execs, list):
                self.error(
                    '%s.filenames should be a string or list of strings, not: %s' %
                    (self.class_name, type(cls.filenames).__name__))
                return

            for alias in execs:
                file = find_executable(alias) or shutil.which(alias)
                if file is not None:
                    cls._executable = file
                    break

        return cls._executable


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
                "%s can't handle action: %s" % (self.class_name, action))

        if os.getenv('skip_package') is not None:
            return True

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
                pacman.run_update()

                if isinstance(packages, str):
                    packages = [packages]

                ret = True
                for package in packages:
                    package = pacman.populate_spec(
                        package, self.cwd, self._context.defaults())
                    if self._log._level <= Level.DEBUG:
                        package['verbose'] = True
                    res = self._process_install(pacman, package)
                    ret &= res

                    if not res:
                        self.error('failed to install package')
                return ret
            else:
                return False

    def _process_install(self, pacman, package):
        if not self._run_test(package['before']):
            self.warn("skipping %s package [%s] because `before' failed" %
                      (pacman.name, package['package']))
            return True

        res = pacman.install(package)
        if not self._run_test(package['after']):
            self.warn("post install command `after' failed")

        return res

    def _run_test(self, test_spec):
        if test_spec:
            if isinstance(test_spec, str):
                test_spec = {'command': test_spec}

            shell = os.getenv('SHELL') or 'sh'
            return run_process([shell, '-c', test_spec['command']], test_spec) == 0
        else:
            return True

    def find_package_manager(self, data):
        tried_pacmans = []
        for _ in data:  # package hash in data list
            for pacman, packages in _.items():
                tried_pacmans.append(pacman)
                for package_manager in self.package_managers():
                    if package_manager.matches(pacman) and \
                       package_manager.exists:
                        return package_manager, packages

        self.error('failed to find package managers, tried: ' + ', '.join(tried_pacmans))

    @property
    def cwd(self):
        return self._context.base_directory()

    _package_managers = None

    def package_managers(self):
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
        cls = type(self)
        if cls._package_managers is None:
            cls._package_managers = [x(log=self) for x in _leaf_subclasses(DotbotPackageManager)]
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
      git:
        type: github
        name: mohkale
    """
    name = 'pip'
    filenames = 'pip'

    def install(self, spec):
        self.fail_if_not_exists()

        package_name = spec['package']

        cmd = [self.executable, 'install']
        if spec['user']:
            cmd += ['--user']

        git = spec['git']
        if git:
            try:
                spec['package'] = self.format_git(spec['package'], git)
            except Exception as e:
                self.error(str(e))
                return False

        self._log_installing(package_name)
        cmd += [spec['package']]
        return self._run_process(cmd, spec) == 0

    def format_git(self, package, git):
        if git['type'] == 'github':
            domain = 'https://github.com'
        else:
            raise ValueError('unknown git type for pip package manger: ' + git['type'])

        return f"git+{domain}/{git['name']}/{package}"

    def populate_spec(self, spec, cwd, defaults):
        spec = super().populate_spec(spec, cwd, defaults)
        spec.setdefault('user', False)
        spec.setdefault('git', False)

        if isinstance(spec['git'], str):
            spec['git'] = {'name': spec['git'],
                           'type': 'github'}

        return spec

class GoPackageManager(DotbotPackageManager):
    """Package manager for golangs module system.
    See also https://github.com/delicb/dotbot-golang

    Spec format

      package: package-name
    """
    name = 'go'
    filenames = 'go'

    def install(self, spec):
        self.fail_if_not_exists()

        cmd = [self.executable, 'get', spec['package']]
        self._log_installing(spec['package'])
        return self._run_process(cmd, spec) == 0

class ChocolateyPackageManager(DotbotPackageManager):
    """Package manager for the chocolatey (windows) package manager.
    See also https://chocolatey.org/

    Spec format

      package: package-name
      params:
        - param1:arg
        - param2
    """
    name = 'chocolatey'
    filenames = 'choco'

    def install(self, spec):
        self.fail_if_not_exists()

        cmd = [self.executable, 'install', '--yes', spec['package']]

        if spec['params']:
            cmd += ['--params', ''.join(spec['params'])]

        self._log_installing(spec['package'])
        return self._run_process(cmd, spec) == 0

    def populate_spec(self, spec, cwd, defaults):
        spec = super().populate_spec(spec, cwd, defaults)
        spec.setdefault('params', [])
        if isinstance(spec['params'], str):
            spec['params'] = [spec['params']]
        return spec

class CygwinPackageManager(DotbotPackageManager):
    name = 'cygwin'
    filenames = 'cyg-get.bat'

    def install(self, spec):
        self.fail_if_not_exists()

        cmd = [self.executable, spec['package']]

        self._log_installing(spec['package'])
        return self._run_process(cmd, spec) == 0

class GemPackageManager(DotbotPackageManager):
    name = 'gem'
    filenames = 'gem'

    def install(self, spec):
        self.fail_if_not_exists()

        cmd = [self.executable, 'install', ]
        if spec['user']:
            cmd += ['--user-install']
        cmd += [spec['package']]
        self._log_installing(spec['package'])
        return self._run_process(cmd, spec) == 0

    def populate_spec(self, spec, cwd, defaults):
        spec = super().populate_spec(spec, cwd, defaults)
        spec.setdefault('user', False)
        return spec

class _ArchPacmanPackageManager(DotbotPackageManager):
    process_kwargs = {}
    sudo = True

    def install(self, spec):
        self.fail_if_not_exists()

        if not self.sudo_validate():
            return False

        self._log_installing(spec['package'])
        cmd = [self.executable, '-S', '--needed', '--noconfirm', spec['package']]
        if self.sudo: cmd.insert(0, 'sudo')
        return self._run_process(cmd, spec) == 0

    def update(self):
        if not self.sudo_validate():
            return False

        self.lowinfo(f'updating package database for: {self.name}')
        ret = self._run_process(
            ['sudo', self.executable, '-Sy'],
            {'interactive': True})
        return ret == 0

class PacmanPackageManager(_ArchPacmanPackageManager):
    name = 'pacman'
    filenames = 'pacman'

class YayPackageManager(_ArchPacmanPackageManager):
    name = 'yay'
    filenames = 'yay'
    sudo = False # yay doesn't allow sudo installs

# class AptPackageManager(DotbotPackageManager):
#     pass

