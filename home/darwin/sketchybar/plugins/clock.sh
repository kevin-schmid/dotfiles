#!/bin/sh

case "$SENDER" in
    mouse.exited.global | front_app_switched)
        sketchybar --set "$NAME" popup.drawing=off
        ;;
    *)
        sketchybar --set "$NAME" label="$(date '+%d/%m %H:%M')"
        ;;
esac
