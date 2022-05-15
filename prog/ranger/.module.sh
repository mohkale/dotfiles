packages pacman:ranger

link                                            \
  "$XDG_CONFIG_HOME/ranger/commands.py"         \
  rangerrc:"$XDG_CONFIG_HOME/ranger/rc.conf"
link-to "$XDG_CONFIG_HOME/autoloads/cmds/" auto/*

link dolphin.desktop:"$XDG_DATA_HOME/kservices5/ServiceMenus/open-ranger.desktop"
