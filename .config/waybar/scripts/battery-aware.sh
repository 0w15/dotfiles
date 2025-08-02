#!/bin/bash

BAT_PATH="/sys/class/power_supply/BAT0"

if [ ! -d "$BAT_PATH" ]; then
  # No battery detected (desktop)
  echo ""
  exit 0
fi

capacity=$(cat "$BAT_PATH/capacity")
status=$(cat "$BAT_PATH/status")

# Choose an icon
if [ "$status" = "Charging" ]; then
  icon=""  # Nerd Font charging
elif [ "$capacity" -gt 80 ]; then
  icon=""
elif [ "$capacity" -gt 60 ]; then
  icon=""
elif [ "$capacity" -gt 40 ]; then
  icon=""
elif [ "$capacity" -gt 20 ]; then
  icon=""
else
  icon=""
fi

echo "{\"icon\": \"$icon\", \"percent\": \"$capacity%\"}"