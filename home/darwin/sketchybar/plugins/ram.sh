#!/bin/sh

case "$SENDER" in
    mouse.exited.global | front_app_switched)
        sketchybar --set "$NAME" popup.drawing=off
        exit 0
        ;;
esac

USED=$(memory_pressure | awk '/free percentage/ { print 100 - $5 }')

sketchybar --set "$NAME" label="${USED}%"
