packages pacman:yakuake

makedir "$XDG_DATA_HOME/yakuake/kns_skins"

sync-submodule themes

link "$XDG_CONFIG_HOME/yakuakerc"
link -i themes/an-old-hope/an-old-hope:"$XDG_DATA_HOME/yakuake/kns_skins/an-old-hope"
