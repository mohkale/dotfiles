clean -r                                        \
  "$XDG_CONFIG_HOME/transmission"               \
  "$XDG_CONFIG_HOME/transmission-cli"

# These need to be accessible in a container so hardlink.
link -Hf                                                      \
  "$XDG_CONFIG_HOME/media-server/transmission/settings.json"  \
  "$XDG_CONFIG_HOME/media-server/transmission/watcher.json"

# Needed to ensure tremc and any other configuration scripts can still access
# Transmission.
link "$XDG_CONFIG_HOME/media-server/transmission":"$XDG_CONFIG_HOME/transmission-daemon"

link                                                    \
  settings.json:"$XDG_CONFIG_HOME/transmission-cli"     \
  "$XDG_CONFIG_HOME/transmission/settings.json"         \
  tremcrc:"$XDG_CONFIG_HOME/tremc/settings.cfg"         \
  "$XDG_CONFIG_HOME/cron-user.d/transmission.cron"

link-to "$XDG_BIN_DIR/" cmds/*
link-to "$XDG_CONFIG_HOME/tmuxp/" ./tmux/*
link-to "$XDG_CONFIG_HOME/autoloads/cmds/" ./auto/*

makedir                                         \
  "$XDG_DOWNLOAD_DIR/incomplete"                \
  "$XDG_MEDIA_HOME/downloads/incomplete"

packages yay:tremc-git
packages pip:libtorrent,asyncinotify,"-r$(pwd)/lib/python/transmission/requirements.txt"

import ..
