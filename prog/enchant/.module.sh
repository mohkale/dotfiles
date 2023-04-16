packages pacman:enchant,aspell,aspell-en

# To avoid shared object loading warnings I install all supported extra
# backends.
# packages pacman:nuspell,libvoikko,hunspell,hspell

link \
  "$XDG_CONFIG_HOME/enchant/enchant.ordering" \
  personal.dic:"$XDG_CONFIG_HOME/enchant/en_GB.dic" \
  exclude.dic:"$XDG_CONFIG_HOME/enchant/en_GB.exc"
