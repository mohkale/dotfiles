packages apt:zsh \
         pacman:zsh \
         msys:zsh

link-to "$XDG_CONFIG_HOME/zshell" ./{bindings,bindings-emacs,bindings-vim,theme}
# As much as it pains me but because zshell doesn't source
# .profile there's no where else I can define ZDOTDIR outside
# of home without messing with /etc/zprofile or other locations.
link ~/.zshenv "$XDG_CONFIG_HOME/zshell"/{.zshrc,.zshenv}
