link \
  "$XDG_CONFIG_HOME/lnxlink/config.yaml" \
  "$XDG_CONFIG_HOME/systemd/user/lnxlink.service" \
  "$XDG_CONFIG_HOME/lnxlink/lnxlink-screen-lock-inhibitor-daemon.py" \
  "$XDG_CONFIG_HOME/systemd/user/lnxlink-screen-lock-inhibitor-daemon.service"

packagex lnxlink
