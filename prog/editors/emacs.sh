install() {
  sync-submodule ./emacs

  # Note: If trying to build from source, see [[https://emacs.stackexchange.com/questions/59538/compile-emacs-from-feature-native-comp-gccemacs-branch-on-ubuntu][here]].
  packages                                      \
    apt:emacs                                   \
    choco:emacs                                 \
    yay:libgccjit,emacs-git

  link "$XDG_CONFIG_HOME/emacs"
  if [ "$(emacs --version | head -n1 | cut -d' ' -f3 | cut -d. -f1)" -le 26 ] 2>/dev/null; then
    link emacs:~/.emacs.d
  fi
  link-to "$XDG_BIN_DIR/" ./emacs/bin/*
}

remove() {
  packages-remove                               \
    apt:emacs                                   \
    choco:emacs                                 \
    yay:libgccjit,emacs-git

  unlink                                        \
    ~/.emacs.d                                  \
    "$XDG_CONFIG_HOME/emacs"
  unlink-from "$XDG_BIN_DIR/" ./emacs/bin/*
}
