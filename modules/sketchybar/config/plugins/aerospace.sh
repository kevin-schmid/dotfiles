#!/bin/sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME label.color=0xFFE1786E
else
    sketchybar --set $NAME label.color=0xffffffff
fi
