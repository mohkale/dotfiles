link ~/.Xresources                                    \
     ~/.xinitrc                                       \
     ~/.xprofile                                      \
     xbindkeysrc:"$XDG_CONFIG_HOME/xbindkeys/config"
link-to "$XDG_CONFIG_HOME/Xresources/" ./Xresources.d/*
link-to "$XDG_BIN_DIR/" ./cmds/*
run-cmd touch "$XDG_CONFIG_HOME/Xresources/local"
run-cmd touch "$XDG_CONFIG_HOME/xprofile.local"

packagex                                        \
  xorg                                          \
  xbindkeys                                     \
  xclip                                         \
  xdotool                                       \
  wmctrl                                        \
  setxkbmap                                     \
  xbindkeys                                     \
  notify-send

if [ -e "$DOTFILES/setup/cache/arch" ]; then
  info 'Installing Graphics Drivers for Xorg'

  case "$("$DOTFILES/bin/ls-graphics-card")" in
    *intel*)
      package pacman xf86-video-intel
      ;;
    *vmware*)
      package pacman xf86-video-vmware
      ;;
    *nvidia*)
      package pacman xf86-video-nouveau
      ;;
    *)
      error "Unable to determine graphics card: $graphics_card" >&2
      ;;
  esac
fi
