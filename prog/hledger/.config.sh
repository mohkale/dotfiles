install() {
  link ledger2beancount.yml:"$XDG_CONFIG_HOME/ledger2beancount/config.yaml"
  link-to "$XDG_DOCUMENTS_DIR/ledger/bin" ./cmds/*
  link-to "$XDG_CONFIG_HOME/tmuxp/" ./tmux/*

  packages yay:hledger-bin,ledger2beancount
  packages pip:fava
}

remove() {
  unlink ledger2beancount.yml:"$XDG_CONFIG_HOME/ledger2beancount/config.yaml"
  unlink-from "$XDG_DOCUMENTS_DIR/ledger/bin" ./cmds/*
  unlink-from "$XDG_CONFIG_HOME/tmuxp/" ./tmux/*

  packages-remove yay:hledger-bin,ledger2beancount
  packages-remove pip:fava
}
