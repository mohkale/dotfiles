# Much-sync doesn't have XDG compliance yet and copies the remote
# notmuch configuration into your home directory by itself :cry:.
link notmuchrc:"$XDG_CONFIG_HOME/notmuch/default/config"

import hooks

packagex notmuch muchsync
