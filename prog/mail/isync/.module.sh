if bots mail.server; then
  link ~/.config/isync/mbsyncrc
  link-to "$XDG_BIN_DIR/" bin/*

  packages pacman:isync
fi
