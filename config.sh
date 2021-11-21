# [[file:setup/dotty][dotty]] configuration file

clean                                           \
  ~/                                            \
  "$XDG_CONFIG_HOME"                            \
  "$XDG_DATA_HOME/applications"

makedir \
  "$XDG_DOCUMENTS_DIR"                          \
  "$XDG_DOWNLOAD_DIR"                           \
  "$XDG_MUSIC_DIR"                              \
  "$XDG_PICTURES_DIR"                           \
  "$XDG_VIDEOS_DIR"                             \
  "$XDG_DESKTOP_DIR"                            \
  "$XDG_PUBLICSHARE_DIR"                        \
  "$XDG_TEMPLATES_DIR"                          \
  "$XDG_CONFIG_HOME"                            \
  "$XDG_CACHE_HOME"                             \
  "$XDG_STATE_HOME"                             \
  "$XDG_DATA_HOME"

# Custom XDG Extensions
makedir \
  "$XDG_TEMP_DIR"                               \
  "$XDG_GAMES_DIR"                              \
  "$XDG_DEV_HOME"/{repos,scripts,conf}

import core

info 'Determining current platform distribution'
dist=setup/cache/dist
rm -r "$dist" 2>/dev/null
mkdir -p "$dist"
platform=$(./bin/ls-distro)
if [ -n "$platform" ]; then
  touch "$dist/$platform"
fi

[ -e "$dist/arch"   ] && import dist/arch
[ -e "$dist/ubuntu" ] && import dist/ubuntu
is-windows            && import dist/windows
is-linux              && import dist/linux

import bin prog
