install() {
  link "$XDG_CONFIG_HOME/imv/config"
  packages yay:imv
}

remove() {
  link "$XDG_CONFIG_HOME/imv/config"
  packages yay:imv
}
