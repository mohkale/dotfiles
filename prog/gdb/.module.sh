clean -r "$XDG_CONFIG_HOME/gdb"

link gdbinit:"$XDG_CONFIG_HOME/gdb/gdbinit"
link-to "$XDG_CONFIG_HOME/gdb/conf.d" conf.d/*
