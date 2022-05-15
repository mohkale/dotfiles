DEPENDENCIES=( bash )

LINK_FORCE=(
  ~/.profile
  "$XDG_CONFIG_HOME/mimeapps.list"
)

if is-windows; then
  LINK_FORCE+=( user-dirs.windows:"~/.config/user-dirs.dirs" )
else
  LINK_FORCE+=( user-dirs:"~/.config/user-dirs.dirs" )
fi

LINK=(
  ~/.ignore
  ~/.config/shenv
  "$XDG_CONFIG_HOME/shenv"
  "$XDG_CONFIG_HOME/mojis"
  "$XDG_CONFIG_HOME/inputrc"
  "$XDG_CONFIG_HOME/prog-icons"
  "$XDG_CONFIG_HOME/dircolors"
  "$XDG_CONFIG_HOME/games.edn"
  "$XDG_CONFIG_HOME/diricons"
  "$XDG_CONFIG_HOME/.curlrc"
  xdgenv:"$XDG_CONFIG_HOME/xdg"
  lesskey:"$XDG_CONFIG_HOME/less/lesskey.base"
  pylog:"$XDG_CONFIG_HOME/pylog/default.yml"
)

before() {
  clean -r "$XDG_DATA_HOME/fonts"
  clean "$XDG_CONFIG_HOME/banners"
}

install() {
  sync-submodule ./walls
  if is-unix; then
    # I prefer to keep wallpapers in XDG_PICTURES_DIR so if linux
    # expects them somewhere else we can just link through to them.
    link -i "$XDG_PICTURES_DIR/wallpapers:$XDG_DATA_HOME/wallpapers"
  fi
  link-to "$XDG_PICTURES_DIR/wallpapers" ./walls/*.{png,jpg,jpeg,gif}

  info 'Installing terminfo declarations'
  run-cmd find "$(pwd)/term" -mindepth 1 -maxdepth 1 -iname '*.terminfo' -exec tic -x {} \;

  link-to "$XDG_CONFIG_HOME/aliases" ./aliases/*
  link-to "$XDG_DATA_HOME/fonts"     ./fonts/*.{ttf,otf}
  link-to "$XDG_CONFIG_HOME/banners" ./banners/*
  link-to "$XDG_PICTURES_DIR/"       ./images/*.{jpg,jpeg,png,gif,svg}
  if is-unix; then
    link ./images/profile.svg:~/.face
  fi
}

after() {
  import                                        \
    auto                                        \
    repos
}
