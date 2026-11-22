#!/bin/sh

USED=$(memory_pressure | awk '/free percentage/ { print 100 - $5 }')

sketchybar --set "$NAME" label="${USED}%"
