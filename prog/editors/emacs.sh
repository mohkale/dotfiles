sync-submodule ./emacs
packages apt:emacs \
         choco:emacs \
         yay:libgccjit,emacs-git

link "$XDG_CONFIG_HOME/emacs"
if [ "$(emacs --version | head -n1 | cut -d' ' -f3 | cut -d. -f1)" -le 26 ] 2>/dev/null; then
  link emacs:~/.emacs.d
fi
link-to "$XDG_BIN_DIR/" ./emacs/bin/*
