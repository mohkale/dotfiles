link-to "$XDG_BIN_DIR/" cmds/*
link-to "$XDG_CONFIG_HOME/tmuxp/" tmux/*

makedir                                         \
  "$XDG_CONFIG_HOME/jellyfin"                   \
  "$XDG_CACHE_HOME/jellyfin"                    \
  "$XDG_CACHE_HOME/jellyfin.empty"

packages yay:jellyfin-media-player

import -f docker
