install() {
  link init.kak:"$XDG_CONFIG_HOME/kak/kakrc"

  packages yay:kakoune-git
}

remove() {
  unlink init.kak:"$XDG_CONFIG_HOME/kak/kakrc"

  packages-remove yay:kakoune-git
}
