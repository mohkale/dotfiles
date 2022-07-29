packages                                        \
  apt:zsh                                       \
  pacman:zsh                                    \
  msys:zsh

link-to "$XDG_CONFIG_HOME/zshell" ./{bindings,bindings-emacs,bindings-vim,theme}
# As much as it pains me but because zshell doesn't source
# .profile there's no where else I can define ZDOTDIR outside
# of home without messing with /etc/zprofile or other locations.
link ~/.zshenv "$XDG_CONFIG_HOME/zshell"/{.zshrc,.zshenv}

# Wayland doesn't really have an init file like xprofile. If you need
# to setup the environment for wayland properly you'll have to fallback
# to the regular shell init files. This is already setup for bash since
# I haven't added XDG compliance to it yet, but if I change my default
# shell to zshell it just won't source any [[https://superuser.com/a/187673][profile]] file and you'll end
# up with a broken login session. To fix this I point zprofile to profile
# so it's sourced by whatever login script eventually runs.
if bots wayland; then
  link ~/.profile:~/.zprofile
fi
