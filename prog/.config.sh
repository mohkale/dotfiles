import                                          \
  git                                           \
  info                                          \
  editors

# Also installs some package managers such as pip or gem.
import -b langs/*

import -b                                       \
  bat                                           \
  browsers/*                                    \
  buku                                          \
  cava                                          \
  cheat                                         \
  desktop/login/sddm                            \
  desktop/plasma                                \
  docker                                        \
  dolphin                                       \
  dropbox                                       \
  ffmpeg                                        \
  games/*                                       \
  gdb                                           \
  gimp                                          \
  gotop                                         \
  hledger                                       \
  hyper                                         \
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
