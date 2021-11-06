sync-submodule themes

link profile:"$XDG_DATA_HOME/konsole/Mohkale.profile" \
     konsolerc:"$XDG_CONFIG_HOME/konsolerc"
link-to "$XDG_DATA_HOME/konsole" themes/an-old-hope/*.colorscheme

packages pacman:konsole
