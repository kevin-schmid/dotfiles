#!/bin/sh

UPDATED=$(jq -r '.nodes.nixpkgs.locked.lastModified' "$HOME/.config/nix/flake.lock")
DAYS=$(( ($(date +%s) - UPDATED) / 86400 ))

if [ "$DAYS" -gt 30 ]; then
    COLOR=0xFFEA9D34
else
    COLOR=0xffffffff
fi

sketchybar --set "$NAME" label="${DAYS}d" label.color="$COLOR"
