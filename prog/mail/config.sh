if bots mail.server; then
  makedir "$XDG_DOCUMENTS_DIR/backups/mail"
  link server.cron:"$XDG_CONFIG_HOME/cron-user.d/notmuch-server.cron"
elif bots mail.client; then
  link client.cron:"$XDG_CONFIG_HOME/cron-user.d/notmuch-client.cron"
  if bots mail.local; then
    packagex postfix
    link local-mail.cron:"$XDG_CONFIG_HOME/cron-user.d/test-local-mail.cron"
  fi
fi

if bots mail.server; then
  import isync
fi

import notmuch
