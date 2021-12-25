packages yay:wireguard-tools,nordvpn-bin

# Nordvpn socket access needs the nordvpn group.
run-cmd sudo usermod -aG nordvpn "$USER"

# Prefer wireguard to openvpn.
run-cmd nordvpn set technology nordlynx
