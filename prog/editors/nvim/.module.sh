DEPENDENCIES=( vim )

PROG_EDITORS_NVIM_PACKAGES=(
  apt:neovim
  pacman:neovim
)

install() {
  link "$XDG_CONFIG_HOME/vim:$XDG_CONFIG_HOME/nvim"

  packages "${PROG_EDITORS_NVIM_PACKAGES[@]}"
}

remove() {
  unlink "$XDG_CONFIG_HOME/vim:$XDG_CONFIG_HOME/nvim"
  packages-remove "${PROG_EDITORS_NVIM_PACKAGES[@]}"
}
