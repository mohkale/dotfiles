link "$XDG_CONFIG_HOME/cheat/conf.yml"
link-to "$XDG_CONFIG_HOME/autoloads/cmds/" auto/*
link-to "$XDG_CONFIG_HOME/cheat/cheatsheets/personal/" sheets/*

packagex cheat
if ! [ -e "$XDG_CONFIG_HOME/cheat/cheatsheets/community" ]; then
  run-cmd git clone https://github.com/cheat/cheatsheets "$XDG_CONFIG_HOME/cheat/cheatsheets/community"
fi
