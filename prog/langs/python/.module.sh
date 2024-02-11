link                                            \
  ~/.pdbrc                                      \
  "$XDG_CONFIG_HOME/pdbrc.py"                   \
  pythonrc:"$XDG_CONFIG_HOME/pythonrc.py"
link-to "$XDG_BIN_DIR" ./cmds/*

# Install python itself
packages                                        \
  apt:python3,python3-pip,python3-pipx          \
  msys:python,python-pip,python-pipx            \
  choco:python                                  \
  pacman:python3,python-pip,python-pipx

# Install the python packages I always want :-)
package pip                                     \
  click                                         \
  pyyaml                                        \
  colorlog                                      \
  requests                                      \
  pyperclip                                     \
  hurry.filesize                                \
  edn_format                                    \
  beautifulsoup4                                \
  git+https://github.com/mohkale/RequestMixin
