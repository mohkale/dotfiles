link "$XDG_CONFIG_HOME/cheat/conf.yml"
link-to "$XDG_CONFIG_HOME/autoloads/cmds/" auto/*
link-to "$XDG_CONFIG_HOME/cheat/cheatsheets/personal/" sheets/*

packages yay:cheat-bin
run-cmd git clone https://github.com/cheat/cheatsheets "$XDG_CONFIG_HOME/cheat/cheatsheets/community"
