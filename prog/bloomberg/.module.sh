link-to "$XDG_BIN_DIR" cmds/*
link-to "$XDG_CONFIG_HOME/tmuxp" tmux/*
link-to "$XDG_CONFIG_HOME/autoloads" auto/*
link \
  "bloomberg.alias:$XDG_CONFIG_HOME/aliases/bloomberg" \
  "$XDG_CONFIG_HOME/bbprofile"

makedir external
if ! [ -e external/gdb/pretty-printers ]; then
  info 'Fetching BDE GDB Pretty Printers'
  run-cmd-at external git clone https://bbgithub.dev.bloomberg.com/gdb/pretty-printers gdb/pretty-printers
fi
link "$(pwd)/external/gdb/pretty-printers/gdb_bsl.py:$XDG_CONFIG_HOME/gdb/gdb_bsl.py"
