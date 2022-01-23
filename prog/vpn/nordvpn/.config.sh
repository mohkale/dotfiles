packages yay:wireguard-tools,nordvpn-bin

# Nordvpn socket access needs the nordvpn group.
run-cmd sudo usermod -aG nordvpn "$USER"

link-to "$XDG_BIN_DIR" ./cmds/*

# Prefer wireguard to openvpn.
# This is disabled for now because I was getting weird
# issues with checksum corruption and transmission.
# run-cmd nordvpn set technology nordlynx
