link                                                                    \
  "$XDG_BIN_DIR/tctl"                                                   \
  "$XDG_BIN_DIR/torvipe"                                                \
  "$XDG_BIN_DIR/magnet2torrent"                                         \
  "$XDG_BIN_DIR/transmission-reload"                                    \
  "$XDG_CONFIG_HOME/transmission-daemon/cmds/transmission-on-complete"  \
  "$XDG_CONFIG_HOME/transmission-daemon/cmds/transmission-watcher"

packages pip:libtorrent,asyncinotify,aiohttp
