# Put any packages you always want to install on linux here.
DEPENDENCIES=( fzf )

if package yay; then
  package yay                                   \
          lsof                                  \
          adobe-source-code-pro-fonts           \
          ttf-symbola                           \
          noto-fonts                            \
          bdf-unifont                           \
          ttf-nerd-fonts-symbols                \
          ttf-meslo                             \
          s-nail                                \
          moreutils                             \
          nmap                                  \
          pv                                    \
          ark                                   \
          trash-cli
fi
