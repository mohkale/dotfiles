install() {
  packages                                      \
    choco:imagemagick                           \
    pacman:imagemagick
}

remove() {
  packages-remove                               \
    choco:imagemagick                           \
    pacman:imagemagick
}
