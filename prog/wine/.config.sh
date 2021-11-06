makedir "$XDG_DATA_HOME/wine/prefixes/default"

link-to "$XDG_BIN_DIR/" cmds/*

packages yay:wine,wine-mono,wine-gecko
