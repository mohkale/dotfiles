packagex mpv mpv-mpris mpv-shim-default-shaders

clean -r "$XDG_CONFIG_HOME/mpv"
link \
    "$XDG_CONFIG_HOME/mpv/mpv.conf" \
    "$XDG_CONFIG_HOME/mpv/input.conf"
link-to "$XDG_CONFIG_HOME/mpv/shaders" /usr/share/mpv-shim-default-shaders/shaders/*
link-to "$XDG_CONFIG_HOME/mpv/fonts" ./fonts/*
link-to "$XDG_CONFIG_HOME/mpv/scripts" ./scripts/*
link-to "$XDG_CONFIG_HOME/mpv/script-opts" ./script-opts/*
link-to "$XDG_CONFIG_HOME/mpv/script-modules" ./script-modules/*

link -i "/usr/lib/mpv-mpris/mpris.so:$XDG_CONFIG_HOME/mpv/scripts/mpris.so"

info 'Building mpv-libunity mpv plugin'
run-cmd-at external-modules/mpv-libunity make
