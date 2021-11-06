packages                                        \
  apt:tmux                                      \
  msys:tmux                                     \
  yay:tmux-git

packages pip:tmuxp

clean -r "$XDG_CONFIG_HOME/tmux"

link                                            \
  tmuxrc:"$XDG_CONFIG_HOME/tmux/tmux.conf"      \
  themerc:"$XDG_CONFIG_HOME/tmux/theme.conf"
link-to "$XDG_BIN_DIR" cmds/*
link-to "$XDG_CONFIG_HOME/autoloads/cmds/" auto/*
link-to "$XDG_CONFIG_HOME/tmux/theme/" theme/*
link-to "$XDG_CONFIG_HOME/tmuxp/" layouts/*

makedir                                         \
  "$XDG_CACHE_HOME/tmux"                        \
  "$XDG_DATA_HOME/tmux"

import "tmux-cmds"
