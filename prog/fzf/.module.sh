makedir "$XDG_DATA_HOME/fzf/history"

# From ubuntu 20.04 this is no longer necessary.
# run-cmd sudo add-apt-repository ppa:x4121/ripgrep
# run-cmd sudo apt update

packages                                      \
  apt:fzf                                     \
  pacman:fzf
