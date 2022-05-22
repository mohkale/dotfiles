packages                                        \
  apt:zsh                                       \
  pacman:zsh                                    \
  msys:zsh

link-to "$XDG_CONFIG_HOME/zshell" ./{bindings,bindings-emacs,bindings-vim,theme}
# As much as it pains me but because zshell doesn't source
# .profile there's no where else I can define ZDOTDIR outside
# of home without messing with /etc/zprofile or other locations.
#
# Note: If you have issues with zshell not sourcing zprofile on
# new GUI sessions (such as with SDDM) it's likely because ~/.profile
# isn't being sourced. In zshells case it's done through zshenv when
# run in a login shell. SDDM doesn't use a login shell for this. To
# work around it you can link ~/.zprofile to ~/.profile.
link ~/.zshenv "$XDG_CONFIG_HOME/zshell"/{.zshrc,.zshenv}
