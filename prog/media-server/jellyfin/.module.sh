link-to "$XDG_CONFIG_HOME/tmuxp/" tmux/*

makedir                                         \
  "$XDG_CONFIG_HOME/media-server/jellyfin"      \
  "$XDG_CACHE_HOME/media-server/jellyfin"

packages yay:jellyfin-media-player,mpv-mpris

link /usr/lib/mpv-mpris/mpris.so ~/.local/share/jellyfinmediaplayer/scripts/

import ..
