packages pacman:base-devel

if true || ! hash yay 2>/dev/null; then
  info 'Installing Yay (Yet Another Yogurt)'
  run-cmds <<-'EOF'
if pushd "$(mktemp -d)" >/dev/null; then
  git clone 'https://aur.archlinux.org/yay.git' .
  makepkg -i --syncdeps --rmdeps --noconfirm
  popd >/dev/null || exit 1
else
  echo 'Failed to change to a temporary directory' >&2
fi
EOF
fi

link-to "$XDG_CONFIG_HOME/autoloads/cmds/" ./auto/*
