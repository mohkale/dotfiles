import "$DOTFILES/prog/chocolatey" \
       "$DOTFILES/prog/desktop/windows"

# Setup msys, the unix like environment for windows
packages choco:msys2,cyg-get

# By default msys uses it's own home directory independent from
# my user home directory. That would require me to have to sync
# my dotfiles in 2 places, so lets just make msys use my real home
# directory.
info "Setting msys Home Directory"
run-cmds <<-'EOF'
conf_file="c:/tools/msys64/etc/nsswitch.conf"
if [ -f "$conf_file" ]; then
  sed -i -e 's/db_home: cygwin desc/db_home: windows/' "$conf_file"
else
  echo "Failed to set msys user home directory, conf file doesn't exist" >&2
fi
EOF

# By default msys completely disregards your user path and
# builds it's own PATH independent from it. Let's prevent that.
info 'Allowing Windows PATH Inheritance'
run-cmds <<-'EOF'
conf_file=c:/tools/msys64/msys2_shell.cmd
if [ -f "$conf_file" ]; then
  sed -i -e 's/rem \(set MSYS2_PATH_TYPE=inherit\)/\1/' "$conf_file"
else
  echo "Failed to set PATH inheritance, conf file doesn't exist" >&2
fi
EOF

packages msys:base-devel,make,gcc,mingw-w64-x86_64-gcc
packages choco:fzf
packages cygwin:envsubst

import "$DOTFILES/prog/git"

# A terminal wrapper to support some modern escape codes on the archaic
# windows platform.
if ! [ -e c:/tools/msys64/usr/local/bin/winpty.exe ]; then
  info 'Installing winpty'
  run-cmds <<-'EOF'
if pushd "$(mktemp -d)" >/dev/null; then
  git clone https://github.com/rprichard/winpty .
  export PATH=/mingw64/bin/:"$PATH"
  ./configure
  make install
  popd >/dev/null || exit 1
else
  echo 'Failed to change to a temporary directory' >&2
fi
EOF
fi

# Some extra cool windows additions
import "$DOTFILES/prog/wsl" \
       "$DOTFILES/prog/cmder"
