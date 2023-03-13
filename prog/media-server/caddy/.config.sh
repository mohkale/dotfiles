makedir                                         \
  "$XDG_CONFIG_HOME/media-server/authelia"      \
  "$XDG_CONFIG_HOME/media-server/caddy/data"    \
  "$XDG_CONFIG_HOME/media-server/caddy/config"

run-cmd-at "$(pwd)" mkdir -p local.d/
run-cmd-at "$(pwd)" touch local.d/Caddyfile.{global,snippets,routes}

import ..
