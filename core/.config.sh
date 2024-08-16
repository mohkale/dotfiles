import shell

link -f "$XDG_CONFIG_HOME/mimeapps.list"

link ~/.ignore                                    \
     "$XDG_CONFIG_HOME/mojis"                     \
     "$XDG_CONFIG_HOME/prog-icons"                \
     "$XDG_CONFIG_HOME/diricons"                  \
     "$XDG_CONFIG_HOME/.curlrc"                   \
     lesskey:"$XDG_CONFIG_HOME/less/lesskey.base" \
     pylog:"$XDG_CONFIG_HOME/pylog/default.yml"

clean -r "$XDG_DATA_HOME/fonts"
link-to "$XDG_DATA_HOME/fonts" ./fonts/*.{ttf,otf}

clean "$XDG_CONFIG_HOME/banners"
link-to "$XDG_CONFIG_HOME/banners" ./banners/*

link-to "$XDG_PICTURES_DIR/" ./images/*.{jpg,jpeg,png,gif,svg}
if is-unix; then
  link ./images/profile.svg:~/.face
fi

import term repos
