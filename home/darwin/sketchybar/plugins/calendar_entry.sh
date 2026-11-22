#!/bin/sh

case "$SENDER" in
    mouse.entered)
        sketchybar --set "$NAME" background.color=0x33E1786E
        ;;
    mouse.exited)
        sketchybar --set "$NAME" background.color=0x00000000
        ;;
    mouse.clicked)
        if "$HOME/.local/bin/jinbe" calendar toggle "$1" | grep -q 'dismissed'; then
            color=0x66ffffff
        else
            color=0xffffffff
        fi
        sketchybar --set "$NAME" icon.color="$color" label.color="$color"
        rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/sketchybar/next_meeting"
        ;;
esac
