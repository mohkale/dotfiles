install() {
  makedir "$XDG_DATA_HOME/fzf/history"

  # run-cmd sudo add-apt-repository ppa:x4121/ripgrep
  # run-cmd sudo apt update

  packages                                      \
    apt:fzf                                     \
    pacman:fzf
}

remove() {
  packages-remove                               \
    apt:fzf                                     \
    pacman:fzf
}
