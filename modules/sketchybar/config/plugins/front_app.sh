#!/bin/sh
case "$SENDER" in
  front_app_switched)
    sketchybar --set "$NAME" label="> $INFO" label.drawing=on
    ;;
  aerospace_workspace_change)
    if [ -z "$(aerospace list-windows --workspace "$FOCUSED_WORKSPACE" 2>/dev/null)" ]; then
      sketchybar --set "$NAME" label.drawing=off
    else
      sketchybar --set "$NAME" label.drawing=on
    fi
    ;;
esac
