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
  ffmpeg                                        \
  games/*                                       \
  gdb                                           \
  gimp                                          \
  gotop                                         \
  hledger                                       \
  imv                                           \
  ipython                                       \
  konsole                                       \
  korganizer                                    \
  lazydocker                                    \
  lf                                            \
  libinput                                      \
  media/*                                       \
  pass                                          \
  polybar                                       \
  ranger                                        \
  ripgrep                                       \
  shells/*                                      \
  spectacle                                     \
  sxiv                                          \
  terminal/*                                    \
  thefuck                                       \
  tmux                                          \
  transmission                                  \
  vpn/*                                         \
  wget                                          \
  wine                                          \
  zathura

if bots mail.server mail.client; then
  import mail
fi
