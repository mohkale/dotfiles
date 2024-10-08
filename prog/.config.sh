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
  avahi                                         \
  bat                                           \
  browsers/*                                    \
  buku                                          \
  cava                                          \
  cookiecutter                                  \
  cron                                          \
  cheat                                         \
  direnv                                        \
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
  nvtop                                         \
  pass                                          \
  polybar                                       \
  ranger                                        \
  rclone                                        \
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
  youtube-dl                                    \
  zathura

if bots mail.server mail.client; then
  import mail
fi
