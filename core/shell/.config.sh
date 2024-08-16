link -f ~/.profile

link ~/.config/shenv                              \
     "$XDG_CONFIG_HOME/shenv"                     \
     "$XDG_CONFIG_HOME/dircolors"                 \
     "$XDG_CONFIG_HOME/inputrc"                   \
     xdgenv:"$XDG_CONFIG_HOME/xdg"

if is-windows; then
  link -f user-dirs.windows:"~/.config/user-dirs.dirs"
else
  link -f user-dirs:"~/.config/user-dirs.dirs"
fi

link-to "$XDG_CONFIG_HOME/aliases" ./aliases/*
import autoloads
