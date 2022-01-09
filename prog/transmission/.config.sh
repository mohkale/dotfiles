link settings.json:"$XDG_CONFIG_HOME/transmission-cli"    \
     "$XDG_CONFIG_HOME/transmission/settings.json"        \
     "$XDG_CONFIG_HOME/transmission-daemon/settings.json" \
     "$XDG_CONFIG_HOME/transmission-daemon/watcher.json"  \
     tremcrc:"$XDG_CONFIG_HOME/tremc/settings.cfg"
link-to "$XDG_CONFIG_HOME/tmuxp/" ./tmux/*

import cmds

if package apt; then
  run-cmd sudo add-apt-repository ppa:transmissionbt/ppa
  run-cmd sudo apt update
  package apt transmission-common transmission-daemon
else
  packages yay:dht,transmission-cli-git,transmission-qt,tremc-git
fi
