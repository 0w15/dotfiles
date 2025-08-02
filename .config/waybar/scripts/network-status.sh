#!/bin/bash

# Silence all stderr output
exec 2>/dev/null

# Get the default network interface
default_dev=$(ip route show default | awk '{print $5}' | head -n1)

# If no default interface, show disconnected
if [[ -z "$default_dev" ]]; then
  echo '{"text": "󰤮 Disconnected", "class": "disconnected", "tooltip": "No active connection"}'
  exit 0
fi

# Determine connection type
dev_type=$(nmcli -t -f DEVICE,TYPE dev | grep "^$default_dev:" | cut -d: -f2)
connection=$(nmcli -t -f DEVICE,CONNECTION dev | grep "^$default_dev:" | cut -d: -f2)
ip_addr=$(ip -4 addr show "$default_dev" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)

# Fallbacks
[ -z "$connection" ] && connection="Unknown"
[ -z "$ip_addr" ] && ip_addr="?"

# Pick icon
case "$dev_type" in
  wifi) icon="󰖩" ;;
  ethernet) icon="󰈁" ;;
  *) icon="" ;;
esac

# Output JSON for Waybar
echo "{\"text\": \"$icon $ip_addr\", \"tooltip\": \"$connection ($default_dev)\", \"class\": \"$dev_type\"}"
