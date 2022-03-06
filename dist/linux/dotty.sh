if package apt; then
  package apt \
          software-properties-common \
          xclip
  run-cmd sudo apt update
else
  package yay \
          lsof \
          adobe-source-code-pro-fonts \
          ttf-symbola \
          noto-fonts \
          bdf-unifont \
          ttf-nerd-fonts-symbols \
          ttf-meslo \
          s-nail \
          moreutils \
          nmap \
          pv \
          fzf \
          ark \
          xclip \
          trash-cli
fi
