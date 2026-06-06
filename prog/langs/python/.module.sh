link                                            \
  ~/.pdbrc                                      \
  "$XDG_CONFIG_HOME/pdbrc.py"                   \
  pythonrc:"$XDG_CONFIG_HOME/pythonrc.py"
link-to "$XDG_BIN_DIR" ./cmds/*

# Install python itself
packagex python3 pipx

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
