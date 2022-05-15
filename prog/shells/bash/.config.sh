link "$XDG_CONFIG_HOME/bash/prompt"             \
     "$XDG_CONFIG_HOME/bash/bindings"

link -f                                         \
  ~/.bashrc                                     \
  logout:"~/.bash_logout"                       \
  profile:"~/.bash_profile"
