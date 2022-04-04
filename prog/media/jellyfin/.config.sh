link-to "$XDG_BIN_DIR" ./cmds/*

packages yay:jellyfin-media-player

import ../../docker
# run-cmd docker-compose -f jellyfin.yml build

import ../kodi
JELLYFIN_KODI_REPO=$XDG_CACHE_HOME/repository.jellyfin.kodi.zip
if ! [ -e "$JELLYFIN_KODI_REPO" ]; then
  run-cmd curl -L --output "$JELLYFIN_KODI_REPO" https://kodi.jellyfin.org/repository.jellyfin.kodi.zip

  # https://jellyfin.org/docs/general/clients/kodi.html#general-use-devices-pcs-and-tablets
  todo "Open KODI and install the jellyfin add-on browser at $JELLYFIN_KODI_REPO"
fi
