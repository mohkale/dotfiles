install() {
  packages pacman:docker,docker-compose

  link-to "$XDG_BIN_DIR/" cmds/*
  link-to "$XDG_CONFIG_HOME/autoloads/cmds/" auto/*
}

remove() {
  packages-remove pacman:docker,docker-compose

  unlink-from "$XDG_BIN_DIR/" cmds/*
  unlink-from "$XDG_CONFIG_HOME/autoloads/cmds/" auto/*
}
