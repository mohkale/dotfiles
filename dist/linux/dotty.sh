if package apt; then
  package apt \
          software-properties-common \
          python-software-properties \
          xclip
  run-cmd sudo add-apt-repository ppa:x4121/ripgrep
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
