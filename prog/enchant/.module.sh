packagex libenchant

link \
  "$XDG_CONFIG_HOME/enchant/enchant.ordering" \
  personal.dic:"$XDG_CONFIG_HOME/enchant/en_GB.dic" \
  exclude.dic:"$XDG_CONFIG_HOME/enchant/en_GB.exc" \
  personal.dic:"$XDG_CONFIG_HOME/enchant/en_US.dic" \
  exclude.dic:"$XDG_CONFIG_HOME/enchant/en_US.exc"
