link "$XDG_CONFIG_HOME/notmuch/default/hooks/post-new"

bots mail.server && link pre-new.server:"$XDG_CONFIG_HOME/notmuch/default/hooks/pre-new"
bots mail.client && link pre-new.client:"$XDG_CONFIG_HOME/notmuch/default/hooks/pre-new"
