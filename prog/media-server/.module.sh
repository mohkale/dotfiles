makedir                                         \
  "$XDG_CONFIG_HOME/media-server"               \
  "$XDG_MEDIA_HOME/content"

link-to "$XDG_BIN_DIR/" cmds/*
link-to "$XDG_CONFIG_HOME/tmuxp" tmux/*

import caddy
import jellyfin
import sonarr
import transmission
