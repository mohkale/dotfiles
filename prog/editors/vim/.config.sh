packages apt:vim                                \
         msys:vim                               \
         choco:vim                              \
         pacman:vim

link "$XDG_CONFIG_HOME/vim/init.vim"            \
     "$XDG_CONFIG_HOME/vim/plugins.vim"         \
     "$XDG_CONFIG_HOME/vim/statusline.vim"
link-to "$XDG_CONFIG_HOME/vim/colors" ./colors/*
link-to "$XDG_CONFIG_HOME/vim/bindings" ./bindings/*

if bots nvim; then
  link "$XDG_CONFIG_HOME/vim:$XDG_CONFIG_HOME/nvim"

  packages apt:neovim                           \
           pacman:neovim
fi

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
