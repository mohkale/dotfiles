# Configuration directories for sonarr related services.
#
# We create them ourselves to prevent Docker creating them as the root user.
makedir                                         \
  "$XDG_CONFIG_HOME/media-server/lidarr"        \
  "$XDG_CONFIG_HOME/media-server/prowlarr"      \
  "$XDG_CONFIG_HOME/media-server/radarr"        \
  "$XDG_CONFIG_HOME/media-server/readarr"       \
  "$XDG_CONFIG_HOME/media-server/shoko"         \
  "$XDG_CONFIG_HOME/media-server/sonarr"

# Download directories. I prefer to have a separate one for each indexer.
makedir                                         \
  "$XDG_MEDIA_HOME/downloads/indexers/lidarr"   \
  "$XDG_MEDIA_HOME/downloads/indexers/radarr"   \
  "$XDG_MEDIA_HOME/downloads/indexers/readarr"  \
  "$XDG_MEDIA_HOME/downloads/indexers/sonarr"

import ..
