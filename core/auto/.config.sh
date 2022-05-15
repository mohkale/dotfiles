before() {
  clean -r "$XDG_CONFIG_HOME/autoloads"
}

install() {
  link "$XDG_CONFIG_HOME/autoloads"/{global,linux,macos,windows}
  link-to "$XDG_CONFIG_HOME/autoloads/cmds/" cmds/*
  link-to "$XDG_CONFIG_HOME/autoloads/shell/" shell/*
}

remove(){
  unlink "$XDG_CONFIG_HOME/autoloads"/{global,linux,macos,windows}
  unlink-from "$XDG_CONFIG_HOME/autoloads/cmds/" cmds/*
  unlink-from "$XDG_CONFIG_HOME/autoloads/shell/" shell/*
}
