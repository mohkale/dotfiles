link -f                                                                 \
   shortcuts:"$XDG_CONFIG_HOME/kglobalshortcutsrc"                      \
   settings:"$XDG_CONFIG_HOME/kdeglobals"                               \
   web-shortcuts-rc:"$XDG_CONFIG_HOME/kuriikwsfilterrc"                 \
   notifyrc:"$XDG_CONFIG_HOME/plasmanotifyrc"                           \
   activityrc:"$XDG_CONFIG_HOME/kactivitymanagerdrc"                    \
   kwinrc:"$XDG_CONFIG_HOME/kwinrc"                                     \
   Mohkale.colors:"$XDG_CONFIG_HOME/share/color-schemes/Mohkale.colors" \
   krunnerrc:"$XDG_CONFIG_HOME/krunnerrc"                               \
   kservicemenurc:"$XDG_CONFIG_HOME/kservicemenurc"                     \
   ktrashrc:"$XDG_CONFIG_HOME/ktrashrc"                                 \
   libinput-gestures.conf:"$XDG_CONFIG_HOME/libinput-gestures.conf"     \
   web-shortcuts:"$XDG_DATA_HOME/kservices5/searchproviders"

import ../xorg

packages pacman:plasma-meta

import "$DOTFILES/prog/dolphin"                 \
       "$DOTFILES/prog/spectacle"
