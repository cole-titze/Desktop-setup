#!/usr/bin/env bash
set -euo pipefail

echo "==> Configuring static IP for active Ethernet interface"

# Auto-detect connected ethernet interface
INTERFACE="$(nmcli -t -f DEVICE,TYPE,STATE device status \
  | awk -F: '$2=="ethernet" && $3=="connected" {print $1; exit}')"

if [[ -z "$INTERFACE" ]]; then
  echo "ERROR: No connected ethernet interface found." >&2
  exit 1
fi

echo "Detected interface: $INTERFACE"

# ===== EDIT THESE =====
STATIC_IP="10.42.0.50/24"
GATEWAY="10.42.0.1"
DNS1="10.42.0.2"
DNS2="10.42.0.2"
# ======================

NETPLAN_FILE="/etc/netplan/99-static.yaml"

sudo tee "$NETPLAN_FILE" > /dev/null <<EOF
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    ${INTERFACE}:
      dhcp4: false
      addresses:
        - ${STATIC_IP}
      routes:
        - to: default
          via: ${GATEWAY}
      nameservers:
        addresses: [${DNS1}, ${DNS2}]
EOF

sudo netplan apply

echo "Static IP applied"