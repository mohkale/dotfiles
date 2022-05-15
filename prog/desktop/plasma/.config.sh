DEPENDENCIES=( xorg )

PROG_PLASMA_LINKS=(
  shortcuts:"$XDG_CONFIG_HOME/kglobalshortcutsrc"
  settings:"$XDG_CONFIG_HOME/kdeglobals"
  web-shortcuts-rc:"$XDG_CONFIG_HOME/kuriikwsfilterrc"
  notifyrc:"$XDG_CONFIG_HOME/plasmanotifyrc"
  activityrc:"$XDG_CONFIG_HOME/kactivitymanagerdrc"
  kwinrc:"$XDG_CONFIG_HOME/kwinrc"
  Mohkale.colors:"$XDG_CONFIG_HOME/share/color-schemes/Mohkale.colors"
  krunnerrc:"$XDG_CONFIG_HOME/krunnerrc"
  kservicemenurc:"$XDG_CONFIG_HOME/kservicemenurc"
  ktrashrc:"$XDG_CONFIG_HOME/ktrashrc"
  web-shortcuts:"$XDG_DATA_HOME/kservices5/searchproviders"
  win-ctrl/win-ctrl.plasma:"$XDG_CONFIG_HOME/win-ctrl/win-ctrl.plasma"
  kwinrulesrc:"$XDG_CONFIG_HOME/kwinrulesrc"
)

install() {
  link -f "${PROG_PLASMA_LINKS[@]}"
  packages pacman:plasma-meta
}

remove() {
  unlink "${PROG_PLASMA_LINKS[@]}"
  packages-remove pacman:plasma-meta
}
