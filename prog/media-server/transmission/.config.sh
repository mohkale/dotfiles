# These need to be accessible in a container so hardlink.
link -Hf                                                      \
  "$XDG_CONFIG_HOME/media-server/transmission/settings.json"

# Needed to ensure tremc and any other configuration scripts can still access
# Transmission.
link "$XDG_CONFIG_HOME/media-server/transmission":"$XDG_CONFIG_HOME/transmission-daemon"

link                                                    \
  tremcrc:"$XDG_CONFIG_HOME/tremc/settings.cfg"

packagex tremc

import ..
