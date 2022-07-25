GIT_CONFIG_DIR="$XDG_CONFIG_HOME/git"
if is-windows; then
  # git on windows looks for the Linux XDG_CONFIG_HOME
  # in place of the windows standard config directories.
  GIT_CONFIG_DIR=~/.config/git
fi

clean -r "$GIT_CONFIG_DIR"

link                                                \
  gitignore:"$GIT_CONFIG_DIR/ignore"                \
  gitconfig:"$GIT_CONFIG_DIR/config"
link-to "$GIT_CONFIG_DIR/config.d/" config.d/*

run-cmd touch "$GIT_CONFIG_DIR/config.d/local"

packages                                        \
  apt:git                                       \
  msys:git                                      \
  choco:git                                     \
  pacman:git
