if copy "config.yaml.in:$XDG_CONFIG_HOME/lnxlink/config.yaml"; then
  info "Copied lnxlink template to $XDG_CONFIG_HOME/lnxlink/config.yaml"
fi
link \
  "$XDG_CONFIG_HOME/systemd/user/lnxlink.service" \
  "$XDG_CONFIG_HOME/lnxlink/lnxlink-screen-lock-inhibitor-daemon.py" \
  "$XDG_CONFIG_HOME/systemd/user/lnxlink-screen-lock-inhibitor-daemon.service"

packagex lnxlink
