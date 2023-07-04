link                                            \
  ~/.pdbrc                                      \
  "$XDG_CONFIG_HOME/pdbrc.py"                   \
  pythonrc:"$XDG_CONFIG_HOME/pythonrc.py"
link-to "$XDG_BIN_DIR" ./cmds/*

# Install python itself
packages                                        \
  apt:python3,python3-pip                       \
  msys:python,python-pip                        \
  choco:python                                  \
  pacman:python3,python-pip

# Install the python packages I always want :-)
package pip                                     \
  pylint                                        \
  pyyaml                                        \
  colorlog                                      \
  requests                                      \
  pyperclip                                     \
  hurry.filesize                                \
  edn_format                                    \
  youtube-dl                                    \
  beautifulsoup4                                \
  git+https://github.com/mohkale/RequestMixin
