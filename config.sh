# [[file:setup/dotty][dotty]] configuration file

DIST_DIRECTORY=setup/cache/dist

before() {
  clean                                           \
    ~/                                            \
    "$XDG_CONFIG_HOME"                            \
    "$XDG_DATA_HOME/applications"

  info 'Determining current platform distribution'
  if ! [ -e "$DIST_DIRECTORY" ]; then
    mkdir -p "$DIST_DIRECTORY"
  fi
  platform=$(./bin/ls-distro)
  if [ -n "$platform" ]; then
    touch "$DIST_DIRECTORY/$platform"
  fi
}

install() {
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
}

after() {
  import core

  [ -e "$DIST_DIRECTORY/arch"   ] && import dist/arch
  [ -e "$DIST_DIRECTORY/ubuntu" ] && import dist/ubuntu
  is-windows && import dist/windows
  is-linux && import dist/linux

  import bin prog
}
