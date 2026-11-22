#!/bin/sh

if [ "$SENDER" = "mouse.clicked" ]; then
    osascript -e 'tell application "Spotify" to playpause'
    exit 0
fi

STATE=$(echo "$INFO" | jq -r '.["Player State"]')
TRACK=$(echo "$INFO" | jq -r '"\(.Artist) - \(.Name)"')

case "$STATE" in
    Playing) sketchybar --set "$NAME" drawing=on label="$TRACK" label.color=0xffffffff icon.color=0xFF1DB954 ;;
    Paused) sketchybar --set "$NAME" drawing=on label="$TRACK" label.color=0x80ffffff icon.color=0x80ffffff ;;
    *) sketchybar --set "$NAME" drawing=off ;;
esac
