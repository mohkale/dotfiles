if bots mail.server; then
  link ~/.config/isync/mbsyncrc
  makedir -m 700 ~/.config/isync/passwords/
  makefile -m 600 \
      ~/.config/isync/passwords/mohkalsin@gmail.com \
      ~/.config/isync/passwords/mohkalex@gmail.com

  link-to "$XDG_BIN_DIR/" bin/*

  packages pacman:isync
fi
