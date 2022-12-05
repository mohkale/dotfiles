import -f mpv docker

link-to "$XDG_BIN_DIR/" cmds/*
link-to "$XDG_CONFIG_HOME/tmuxp/" tmux/*

makedir                                         \
  "$XDG_CONFIG_HOME/jellyfin"                   \
  "$XDG_CACHE_HOME/jellyfin"                    \
  "$XDG_CACHE_HOME/jellyfin.empty"

packages yay:jellyfin-media-player,mpv-mpris

link /usr/lib/mpv-mpris/mpris.so ~/.local/share/jellyfinmediaplayer/scripts/
