link -H                                                                     \
  "$XDG_CONFIG_HOME/media-server/qbittorrent/qBittorrent/qBittorrent.conf"  \
  "$XDG_CONFIG_HOME/media-server/qbittorrent/qBittorrent/categories.json"

link -Hf                                                                    \
  "$XDG_CONFIG_HOME/media-server/qbittorrent/client-settings.json"          \
  cli-settings.json:"$HOME/.qbt/settings.json"

packagex qbittorrent-cli
