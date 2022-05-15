install() {
  link "$XDG_CONFIG_HOME/cheat/conf.yml"
  link-to "$XDG_CONFIG_HOME/autoloads/cmds/" auto/*
  link-to "$XDG_CONFIG_HOME/cheat/cheatsheets/personal/" sheets/*

  package yay cheat-bin
}

remove() {
  unlink "$XDG_CONFIG_HOME/cheat/conf.yml"
  unlink-from "$XDG_CONFIG_HOME/autoloads/cmds/" auto/*
  unlink-from "$XDG_CONFIG_HOME/cheat/cheatsheets/personal/" sheets/*

  package-remove yay cheat-bin
}
