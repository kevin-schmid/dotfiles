#!/bin/sh

if [ "$(sketchybar --query "$NAME" | jq -r '.popup.drawing')" = "on" ]; then
    sketchybar --set "$NAME" popup.drawing=off
    exit 0
fi

sketchybar --remove '/calendar\..*/' >/dev/null 2>&1
sketchybar --add item calendar.loading popup."$NAME" \
    --set calendar.loading icon.drawing=off label="Loading..." \
    --set "$NAME" popup.drawing=on

"$HOME/.local/bin/jinbe" calendar list \
    | grep 'dismissed=false' \
    | head -n 10 \
    | awk -F ' [|] ' '{ print $2 "|" $1 }' \
    | {
        i=0
        previous_day=""
        while IFS='|' read -r start title; do
            epoch=$(date -j -u -f '%Y-%m-%dT%H:%M:%SZ' "$start" +%s)
            day=$(date -r "$epoch" '+%a %d %b')

            if [ "$day" != "$previous_day" ]; then
                sketchybar --add item "calendar.$i" popup."$NAME" \
                    --set "calendar.$i" icon.drawing=off label="$day" label.color=0xFFE1786E
                i=$((i + 1))
                previous_day="$day"
            fi

            sketchybar --add item "calendar.$i" popup."$NAME" \
                --set "calendar.$i" icon="$(date -r "$epoch" '+%H:%M')" label="$title" label.max_chars=40
            i=$((i + 1))
        done

        if [ "$i" -eq 0 ]; then
            sketchybar --add item calendar.0 popup."$NAME" \
                --set calendar.0 icon.drawing=off label="No upcoming meetings"
        fi
    }

sketchybar --remove calendar.loading
