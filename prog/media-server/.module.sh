# Core configuration directories for the media-server.
makedir                                         \
  "$XDG_CONFIG_HOME/media-server"               \
  "$XDG_MEDIA_HOME/content"                     \
  "$XDG_MEDIA_HOME/downloads"

# Configuration directories for services.
#
# We create them ourselves to prevent Docker creating them as the root user.
makedir                                         \
  "$XDG_CACHE_HOME/media-server/jellyfin"       \
  "$XDG_CONFIG_HOME/media-server/jellyfin"      \
                                                \
  "$XDG_CONFIG_HOME/media-server/lidarr"        \
  "$XDG_CONFIG_HOME/media-server/navidrome"     \
  "$XDG_CONFIG_HOME/media-server/prowlarr"      \
  "$XDG_CONFIG_HOME/media-server/radarr"        \
  "$XDG_CONFIG_HOME/media-server/readarr"       \
  "$XDG_CONFIG_HOME/media-server/shoko"         \
  "$XDG_CONFIG_HOME/media-server/sonarr"        \
                                                \
  "$XDG_CONFIG_HOME/media-server/authelia"      \
  "$XDG_CONFIG_HOME/media-server/caddy/data"    \
  "$XDG_CONFIG_HOME/media-server/caddy/config"

# Download directories. I prefer to have a separate one for each indexer.
makedir                                         \
  "$XDG_MEDIA_HOME/downloads/indexers/lidarr"   \
  "$XDG_MEDIA_HOME/downloads/indexers/radarr"   \
  "$XDG_MEDIA_HOME/downloads/indexers/readarr"  \
  "$XDG_MEDIA_HOME/downloads/indexers/sonarr"

link-to "$XDG_BIN_DIR/" cmds/*
link-to "$XDG_CONFIG_HOME/tmuxp" tmux/*
link-to "$XDG_CONFIG_HOME/autoloads/cmds/" ./auto/*

link                                                    \
  "$XDG_CONFIG_HOME/cron-user.d/media-server.cron"      \
  "$XDG_CONFIG_HOME/systemd/user/media-server.service"

makedir "$(pwd)/proxy/local.d"
run-cmd-at "$(pwd)/proxy" touch local.d/Caddyfile.{global,snippets,routes}

packagex jellyfin-media-player mpv-mpris
link /usr/lib/mpv-mpris/mpris.so:~/.local/share/jellyfinmediaplayer/scripts/mpris.so
package pip pandas "-r$(pwd)/lib/requirements.txt"

import watcher qbittorrent transmission
