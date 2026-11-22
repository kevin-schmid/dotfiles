#!/bin/sh

FOCUS=0xFFE1786E
DEFAULT=0xffffffff
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/next_meeting"

case "$SENDER" in
    mouse.exited.global | front_app_switched)
        sketchybar --set "$NAME" popup.drawing=off
        exit 0
        ;;
esac

now=$(date +%s)

if [ ! -f "$CACHE" ] || [ $((now - $(stat -f %m "$CACHE"))) -ge 60 ]; then
    mkdir -p "$(dirname "$CACHE")"
    "$HOME/.local/bin/jinbe" calendar list \
        | grep 'dismissed=false' \
        | awk -F ' [|] ' '{ print $2 "|" $3 }' \
        | while IFS='|' read -r start end; do
            s=$(date -j -u -f '%Y-%m-%dT%H:%M:%SZ' "$start" +%s)
            e=$(date -j -u -f '%Y-%m-%dT%H:%M:%SZ' "$end" +%s)
            if [ $((e - s)) -lt 86400 ] && [ "$s" -gt "$now" ]; then
                echo "$s"
            fi
        done \
        | sort -n | head -n 1 > "$CACHE"
fi

color=$DEFAULT
next=$(cat "$CACHE")
if [ -n "$next" ]; then
    left=$((next - now))
    if [ "$left" -gt 0 ] && [ "$left" -le 300 ]; then
        [ $((now % 2)) -eq 0 ] && color=$FOCUS
    elif [ "$left" -gt 0 ] && [ "$left" -le 900 ]; then
        color=$FOCUS
    fi
fi

sketchybar --set "$NAME" label="$(date '+%d/%m %H:%M')" label.color="$color" icon.color="$color"
