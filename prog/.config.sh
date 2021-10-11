import                                          \
  git                                           \
  shells/bash                                   \
  info                                          \
  editors

# Also installs some package managers such as pip or gem.
import -b langs/*

import                                          \
  desktop

import -b                                       \
  bat                                           \
  browsers/*                                    \
  buku                                          \
  cava                                          \
  cheat                                         \
  docker                                        \
  dolphin                                       \
  dropbox                                       \
  dunst                                         \
  ffmpeg                                        \
  games/*                                       \
  gdb                                           \
  gimp                                          \
  gotop                                         \
  hledger                                       \
  imv                                           \
  i3lock                                        \
  ipython                                       \
  konsole                                       \
  korganizer                                    \
  lazydocker                                    \
  lf                                            \
  libinput                                      \
  media/*                                       \
  pass                                          \
  picom                                         \
  polybar                                       \
  ranger                                        \
  ripgrep                                       \
  shells/*                                      \
  spectacle                                     \
  sxiv                                          \
  terminal/*                                    \
  thefuck                                       \
  tint2                                         \
  tmux                                          \
  transmission                                  \
  vpn/*                                         \
  wget                                          \
  wine                                          \
  xsecurelock                                   \
  xwallpaper                                    \
  zathura

if bots mail.server mail.client; then
  import mail
fi
