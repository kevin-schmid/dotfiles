#!/bin/sh

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

if [ "$1" = "$FOCUSED" ]; then
    sketchybar --animate tanh 15 --set "$NAME" label.color=0xFFE1786E
else
    sketchybar --animate tanh 15 --set "$NAME" label.color=0xffffffff
fi
