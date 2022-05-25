link ledger2beancount.yml:"$XDG_CONFIG_HOME/ledger2beancount/config.yaml"
link-to "$XDG_DOCUMENTS_DIR/ledger/bin" ./cmds/*
link-to "$XDG_CONFIG_HOME/tmuxp/" ./tmux/*

packages yay:hledger-bin,ledger2beancount
packages pip:fava
