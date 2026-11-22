#!/bin/sh

LOAD=$(ps -A -o %cpu= | awk -v cores="$(sysctl -n hw.ncpu)" '
    { sum += $1 }
    END { load = sum / cores; if (load > 100) load = 100; printf "%d", load }')

sketchybar --set "$NAME" label="${LOAD}%"
