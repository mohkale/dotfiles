# These need to be accessible in a container so hardlink.
link -Hf                                                      \
  "$XDG_CONFIG_HOME/media-server/transmission/watcher.json"   \
  "$XDG_CONFIG_HOME/media-server/qbittorrent/watcher.json"
