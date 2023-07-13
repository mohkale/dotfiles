sync-submodule ./emacs

# Note: If trying to build from source, see [[https://emacs.stackexchange.com/questions/59538/compile-emacs-from-feature-native-comp-gccemacs-branch-on-ubuntu][here]].
packagex emacs

link "$XDG_CONFIG_HOME/emacs"
if [ "$(emacs --version | head -n1 | cut -d' ' -f3 | cut -d. -f1)" -le 26 ] 2>/dev/null; then
  link emacs:~/.emacs.d
fi
link-to "$XDG_BIN_DIR/" ./emacs/bin/*
