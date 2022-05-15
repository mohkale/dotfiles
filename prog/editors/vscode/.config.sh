install() {
  packages                                      \
    yay:vscodium-bin,vscodium-bin-marketplace   \
    choco:vscodium

  link                                                \
    "$XDG_CONFIG_HOME/VSCodium/User/settings.json"    \
    "$XDG_CONFIG_HOME/VSCodium/User/keybindings.json"

  info "Installing vscode extensions"
  run-cmds <<-"EOF"
sed -e 's/ *//g' -e 's/#.*$//' <<EOP |
  dustinsanders.an-old-hope-theme-vscode
  2gua.rainbow-brackets
  wayou.vscode-todo-highlight
EOP
xargs -r -d '\n' -n1 codium --install-extension
EOF
}

remove() {
  packages-remove                               \
    yay:vscodium-bin,vscodium-bin-marketplace   \
    choco:vscodium

  unlink                                              \
    "$XDG_CONFIG_HOME/VSCodium/User/settings.json"    \
    "$XDG_CONFIG_HOME/VSCodium/User/keybindings.json"
}
