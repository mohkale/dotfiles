clean -r "$XDG_CONFIG_HOME/autoloads"

link "$XDG_CONFIG_HOME/autoloads"/{global,linux,macos,windows}
link-to "$XDG_CONFIG_HOME/autoloads/cmds/" cmds/*
link-to "$XDG_CONFIG_HOME/autoloads/shell/" shell/*
