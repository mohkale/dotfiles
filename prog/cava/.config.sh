install() {
  link "$XDG_CONFIG_HOME/cava/config"

  packages yay:cava-git
}

remove() {
  unlink "$XDG_CONFIG_HOME/cava/config"

  packages-remove yay:cava-git
}
