if is-windows; then
  link                                          \
    gitconfig:~/.config/git/config              \
    gitignore:~/.config/git/gitignore
else
  link                                          \
    gitconfig:"$XDG_CONFIG_HOME/git/config"     \
    gitignore:"$XDG_CONFIG_HOME/git/gitignore"
fi

packages                                        \
  apt:git                                       \
  msys:git                                      \
  choco:git                                     \
  pacman:git
