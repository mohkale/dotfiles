link ~/.Xresources                                    \
     ~/.xinitrc                                       \
     ~/.xprofile                                      \
     xbindkeysrc:"$XDG_CONFIG_HOME/xbindkeys/config"
link-to "$XDG_CONFIG_HOME/Xresources/" ./Xresources.d/*
run-cmd touch "$XDG_CONFIG_HOME/Xresources/local"

packages yay:xorg,xorg-xinit,xbindkeys,xorg-setxkbmap,wmctrl,xdotool
packages pip:notify-send

if [ -e "$DOTFILES/setup/cache/arch" ]; then
  info 'Installing Graphics Drivers for Xorg'
  run-cmds <<-"EOF"
graphics_card=$(lspci | grep -e VGA -e 3D |
                  rev | cut -d: -f1 | rev |
                  sed -e 's/^ *//' -e 's/ *$//' |
                  tr '[:upper:]' '[:lower:]')

case "$graphics_card" in
  *intel*)
    sudo pacman -S --needed --noconfirm xf86-video-intel
    ;;
  *vmware*)
    sudo pacman -S --needed --noconfirm xf86-video-vmware
    ;;
  *nvidia*)
    sudo pacman -S --neded --noconfirm xf86-video-nouveau
    ;;
  *)
    echo "Unable to determine graphics card: $graphics_card" >&2
    ;;
esac
EOF
fi
