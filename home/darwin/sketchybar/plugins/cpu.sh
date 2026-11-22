#!/bin/sh

case "$SENDER" in
    mouse.exited.global | front_app_switched)
        sketchybar --set "$NAME" popup.drawing=off
        exit 0
        ;;
esac

LOAD=$(ps -A -o %cpu= | awk -v cores="$(sysctl -n hw.ncpu)" '
    { sum += $1 }
    END { load = sum / cores; if (load > 100) load = 100; printf "%d", load }')

sketchybar --set "$NAME" label="${LOAD}%"
