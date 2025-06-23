#!/bin/sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME label.color=0xFF6EC3B4
else
    sketchybar --set $NAME label.color=0xffffffff
fi
