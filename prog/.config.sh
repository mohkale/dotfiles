import                                          \
  git                                           \
  info                                          \
  editors

# Also installs some package managers such as pip or gem.
import -b langs/*

import -b                                       \
  alacritty                                     \
  bat                                           \
  browsers/*                                    \
  cava                                          \
  cheat                                         \
  desktop/login/sddm                            \
  desktop/plasma                                \
  dolphin                                       \
  dropbox                                       \
  games/*                                       \
  gdb                                           \
  gimp                                          \
  gotop                                         \
  hledger                                       \
  hyper                                         \
  imv                                           \
  ipython                                       \
  kitty                                         \
  konsole                                       \
  korganizer                                    \
  lf                                            \
  lint/*                                        \
  media/*                                       \
  pass                                          \
  polybar                                       \
  ranger                                        \
  ripgrep                                       \
  spectacle                                     \
  st                                            \
  sxiv                                          \
  thefuck                                       \
  tmux                                          \
  transmission                                  \
  wget                                          \
  windows-terminal                              \
  wine                                          \
  yakuake                                       \
  zathura

if bots mail.server mail.client; then
  import mail
fi
