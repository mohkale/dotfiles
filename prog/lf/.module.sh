packages                                        \
  yay:lf-git                                    \
  choco:lf                                      \
  go:github.com/gokcehan/lf

clean -r "$XDG_CONFIG_HOME/lf"

link "$XDG_CONFIG_HOME/lf/lfrc"
link-to "$XDG_BIN_DIR" ./cmds/*
link-to "$XDG_CONFIG_HOME/autoloads/cmds/" ./auto/*
link-to "$XDG_CONFIG_HOME/lf/auto/" ./utils/*
link-to "$XDG_CONFIG_HOME/lf/cmds/" ./lf-cmds/*

link dolphin.desktop:"$XDG_DATA_HOME/kservices5/ServiceMenus/open-lf.desktop"

if is-windows; then
  link ~/AppData/Local/lf/lfrc
fi
