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
  cookiecutter                                  \
  cron                                          \
  cheat                                         \
  docker                                        \
  dolphin                                       \
  dropbox                                       \
  enchant                                       \
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
  media-server                                  \
  media-server/transmission                     \
  media-server/qbittorrent                      \
  network-manager                               \
  pass                                          \
  polybar                                       \
  ranger                                        \
  ripgrep                                       \
  shells/*                                      \
  smart                                         \
  spectacle                                     \
  sxiv                                          \
  terminal/*                                    \
  thefuck                                       \
  tmux                                          \
  vpn/*                                         \
  wget                                          \
  wine                                          \
  zathura

if bots mail.server mail.client; then
  import mail
fi
