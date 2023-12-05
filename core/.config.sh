link -f                                         \
     ~/.profile                                 \
     "$XDG_CONFIG_HOME/mimeapps.list"

link ~/.ignore                                    \
     ~/.config/shenv                              \
     "$XDG_CONFIG_HOME/shenv"                     \
     "$XDG_CONFIG_HOME/mojis"                     \
     "$XDG_CONFIG_HOME/inputrc"                   \
     "$XDG_CONFIG_HOME/prog-icons"                \
     "$XDG_CONFIG_HOME/dircolors"                 \
     "$XDG_CONFIG_HOME/games.edn"                 \
     "$XDG_CONFIG_HOME/diricons"                  \
     "$XDG_CONFIG_HOME/.curlrc"                   \
     xdgenv:"$XDG_CONFIG_HOME/xdg"                \
     lesskey:"$XDG_CONFIG_HOME/less/lesskey.base" \
     pylog:"$XDG_CONFIG_HOME/pylog/default.yml"

if is-windows; then
  link -f user-dirs.windows:"~/.config/user-dirs.dirs"
else
  link -f user-dirs:"~/.config/user-dirs.dirs"
fi

makedir "$XDG_DATA_HOME/fzf/history"

sync-submodule ./walls
if is-unix; then
  # I prefer to keep wallpapers in XDG_PICTURES_DIR so if linux
  # expects them somewhere else we can just link through to them.
  link -i "$XDG_PICTURES_DIR/wallpapers:$XDG_DATA_HOME/wallpapers"
fi
link-to "$XDG_PICTURES_DIR/wallpapers" ./walls/*.{png,jpg,jpeg,gif}

clean -r "$XDG_DATA_HOME/fonts"
link-to "$XDG_DATA_HOME/fonts" ./fonts/*.{ttf,otf}

clean "$XDG_CONFIG_HOME/banners"
link-to "$XDG_CONFIG_HOME/banners" ./banners/*

link-to "$XDG_PICTURES_DIR/" ./images/*.{jpg,jpeg,png,gif,svg}
if is-unix; then
  link ./images/profile.svg:~/.face
fi

link-to "$XDG_CONFIG_HOME/aliases" ./aliases/*

import auto term repos
