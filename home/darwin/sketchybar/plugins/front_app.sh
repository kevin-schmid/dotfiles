#!/bin/sh
case "$SENDER" in
  front_app_switched)
    sketchybar --set "$NAME" label="$INFO" label.drawing=on \
      --set separator.0 drawing=on
    ;;
  aerospace_workspace_change)
    if [ -z "$(aerospace list-windows --workspace "$FOCUSED_WORKSPACE" 2>/dev/null)" ]; then
      DRAWING=off
    else
      DRAWING=on
    fi
    sketchybar --set "$NAME" label.drawing=$DRAWING \
      --set separator.0 drawing=$DRAWING
    ;;
esac
