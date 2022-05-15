install() {
  packages                                      \
    pacman:gimp                                 \
    choco:gimp

  link "$XDG_CONFIG_HOME/GIMP/2.10/menurc"
}

remove() {
  packages-remove                               \
    pacman:gimp                                 \
    choco:gimp

  unlink "$XDG_CONFIG_HOME/GIMP/2.10/menurc"
}
