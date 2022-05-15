install() {
  link                                              \
    "$XDG_CONFIG_HOME/dolphinrc"                    \
    "$XDG_DATA_HOME/kxmlgui5/dolphin/dolphinui.rc"

  packages pacman:dolphin
}

remove() {
  unlink                                            \
    "$XDG_CONFIG_HOME/dolphinrc"                    \
    "$XDG_DATA_HOME/kxmlgui5/dolphin/dolphinui.rc"

  packages-remove pacman:dolphin
}
