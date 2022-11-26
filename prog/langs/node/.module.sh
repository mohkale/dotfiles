link                                            \
  "$XDG_CONFIG_HOME/npm/npmrc"                  \
  "$XDG_CONFIG_HOME/yarn/yarnrc"                \
  yarnrc:"$XDG_CONFIG_HOME/yarn/config"

if package apt; then
  if hash node 2>/dev/null; then
    run-cmds <<< 'curl -sL https://deb.nodesource.com/setup_13.x | sudo bash -'
  fi

  if hash yarnpkg >/dev/null 2>&1; then
    run-cmds <<-"EOF"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

yarn_source='deb https://dl.yarnpkg.com/debian/ stable main'
list_file=/etc/apt/sources.list.d/yarn.list

if [ -e "$list_file" ]; then
  cat "$list_file" |
    awk -e '{ print($0) }' -e 'END { printf("'"$yarn_source"'") }' |
    sort | uniq
else
  echo "$yarn_source"
fi | sudo tee "$list_file"

sudo apt update
EOF
  fi

  package apt nodejs yarn
else
  packages                                      \
    choco:nodejs,yarn                           \
    pacman:nodejs,npm,yarn
fi
