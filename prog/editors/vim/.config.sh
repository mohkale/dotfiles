PROG_EDITORS_VIM_PACKAGES=(
  apt:vim
  msys:vim
  choco:vim
  pacman:vim
)

install() {
  packages "${PROG_EDITORS_VIM_PACKAGES[@]}"

  link                                          \
    "$XDG_CONFIG_HOME/vim/init.vim"             \
    "$XDG_CONFIG_HOME/vim/plugins.vim"          \
    "$XDG_CONFIG_HOME/vim/statusline.vim"
  link-to "$XDG_CONFIG_HOME/vim/colors" ./colors/*
  link-to "$XDG_CONFIG_HOME/vim/bindings" ./bindings/*

  if ! [ -f "$XDG_CONFIG_HOME/vim/autoload/plug.vim" ]; then
    info 'Installing vim Plugged'
    run-cmds <<-"EOF"
if hash nvim 2>/dev/null; then vim=nvim; else vim=vim; fi

# For some dumb reason, you can't change where the autoload directory is.
autoload_path="$XDG_CONFIG_HOME/vim/autoload/plug.vim"
autoload_url='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if ! [ -f "$autoload_path" ]; then
  curl -fLo "$autoload_path" --create-dirs "$autoload_url"
else
  true
fi && "$vim" -n -e +PlugInstall +qall!
EOF
  fi
}

remove() {
  packages-remove "${PROG_EDITORS_VIM_PACKAGES[@]}"

  unlink                                        \
    "$XDG_CONFIG_HOME/vim/init.vim"             \
    "$XDG_CONFIG_HOME/vim/plugins.vim"          \
    "$XDG_CONFIG_HOME/vim/statusline.vim"
  unlink-from "$XDG_CONFIG_HOME/vim/colors" ./colors/*
  unlink-from "$XDG_CONFIG_HOME/vim/bindings" ./bindings/*
}
