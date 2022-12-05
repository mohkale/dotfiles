clean -r "$XDG_CONFIG_HOME/gdb"

link gdbinit:"$XDG_CONFIG_HOME/gdb/init"
link-to "$XDG_CONFIG_HOME/gdb/conf.d" conf.d/*
