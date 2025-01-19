makedir "$XDG_CACHE_HOME/mpd"

link                                            \
  "$XDG_CONFIG_HOME/mpd/mpd.conf"               \
  "$XDG_CONFIG_HOME/mpDris2/mpDris2.conf"
link-to "$XDG_BIN_DIR" ./cmds/*
link-to "$XDG_CONFIG_HOME/tmuxp/" ./tmux/*

packages                                        \
  choco:mpd                                     \
  yay:mpd,mpc,mpdris2

if ! bots ncmpc ncmpcpp; then
  import clients/ncmpcpp
else
  import -b                                     \
    clients/ncmpc                               \
    clients/ncmpcpp
fi
