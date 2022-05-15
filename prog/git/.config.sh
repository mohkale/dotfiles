PROG_GIT_LINKS=( )

if is-windows; then
  PROG_GIT_LINKS+=(
    gitconfig:~/.config/git/config
    gitignore:~/.config/git/gitignore
  )
else
  PROG_GIT_LINKS+=(
    gitconfig:"$XDG_CONFIG_HOME/git/config"
    gitignore:"$XDG_CONFIG_HOME/git/gitignore"
  )
fi

PROG_GIT_PACKAGES=(
  apt:git
  msys:git
  choco:git
  pacman:git
)

install() {
  link "${PROG_GIT_LINKS[@]}"
  packages "${PROG_GIT_PACKAGES[@]}"
}

remove() {
  link "${PROG_GIT_LINKS[@]}"
  packages "${PROG_GIT_PACKAGES[@]}"
}
