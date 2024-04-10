clean -r "$XDG_CONFIG_HOME/gdb"

link \
    "$XDG_CONFIG_HOME/gdb/gdbinit" \
    "$XDG_CONFIG_HOME/gdb/gdbearlyinit"
link-to "$XDG_CONFIG_HOME/gdb/conf.d" conf.d/*
