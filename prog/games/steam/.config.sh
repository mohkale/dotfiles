PROG_GAMES_STEAM_PACKAGES=(
  choco:steam
  yay:steam,lib32-systemd,ttf-liberation,pulseaudio-alsa
)

install() {
  packages "${PROG_GAMES_STEAM_PACKAGES[@]}"
}

remove() {
  packages-remove "${PROG_GAMES_STEAM_PACKAGES[@]}"
}
