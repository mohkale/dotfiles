link vale.ini:"$XDG_CONFIG_HOME/vale/.vale.ini"
makedir "$XDG_CONFIG_HOME/vale/styles"

packagex vale
run-cmd-at "$XDG_CONFIG_HOME/vale" vale sync
