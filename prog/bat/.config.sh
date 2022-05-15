PROG_BAT_LINKS=(
  batrc:"$XDG_CONFIG_HOME/bat/config"
  an-old-hope/an-old-hope.tmTheme:"$XDG_CONFIG_HOME/bat/themes/an-old-hope.tmTheme"
)

install() {
  packages                                      \
    pacman:bat                                  \
    apt:bat

  sync-submodule ./an-old-hope
  link "${PROG_BAT_LINKS[@]}"
}

remove() {
  packages-remove                               \
    pacman:bat                                  \
    apt:bat

  unlink "${PROG_BAT_LINKS[@]}"
}
