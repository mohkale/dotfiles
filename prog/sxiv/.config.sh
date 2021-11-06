clean -r "$XDG_CONFIG_HOME/sxiv"

sync-submodule src

link                                            \
  "$XDG_CONFIG_HOME/nsxiv/exec/key-handler"     \
  "$XDG_CONFIG_HOME/nsxiv/exec/image-info"

info 'Installing sxiv'
run-cmd-at src make install
