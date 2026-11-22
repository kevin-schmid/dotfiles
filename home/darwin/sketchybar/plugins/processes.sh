#!/bin/sh

if [ "$(sketchybar --query "$NAME" | jq -r '.popup.drawing')" = "on" ]; then
    sketchybar --set "$NAME" popup.drawing=off
    exit 0
fi

sketchybar --remove "/$NAME\.process\..*/" >/dev/null 2>&1

# RAM uses top's memory footprint (as in Activity Monitor): ps RSS misses
# GPU and compressed memory, e.g. a local LLM showing 85 MB instead of 27 GB.
case "$1" in
    cpu)
        VALUE_WIDTH=56
        USAGE=$(ps -Aeo pid=,pcpu=)
        ;;
    ram)
        VALUE_WIDTH=72
        USAGE=$(top -l 1 -stats pid,mem | awk '$1 ~ /^[0-9]+$/ {
            value = $2; sub(/[+-]$/, "", value)
            unit = substr(value, length(value))
            factor = (unit == "G") ? 1024 : (unit == "M") ? 1 : (unit == "K") ? 1 / 1024 : 1 / 1048576
            print $1, value * factor
        }')
        ;;
esac

# Helpers are grouped under the outermost .app bundle in their path,
# e.g. Firefox.app/.../plugin-container.app counts as Firefox.
ROWS=$(printf '%s\n' "$USAGE" \
    | awk '
        BEGIN {
            while (("ps -Aeo pid=,comm=" | getline line) > 0) {
                split(line, fields, " ")
                sub(/^ *[0-9]+ /, "", line)
                path[fields[1]] = line
            }
        }
        $1 in path {
            app = path[$1]
            if (match(app, /[^\/]+\.app\//)) {
                app = substr(app, RSTART, RLENGTH - 5)
            } else {
                sub(/.*\//, "", app)
            }
            total[app] += $2
        }
        END { for (app in total) printf "%f|%s\n", total[app], app }' \
    | sort -t '|' -k 1,1 -rn \
    | head -n 10 \
    | awk -F '|' -v mode="$1" '{
        if (mode == "cpu") value = sprintf("%.1f%%", $1)
        else if ($1 >= 1024) value = sprintf("%.1f GB", $1 / 1024)
        else value = sprintf("%d MB", $1)
        print value "|" $2
    }')

# sketchybar ignores leading whitespace when measuring text, so values are
# right-aligned in a fixed-width icon instead of being padded with spaces.
NAME_WIDTH=$(printf '%s\n' "$ROWS" | awk -F '|' '{ if (length($2) > max) max = length($2) } END { print int(max * 9) + 40 }')

printf '%s\n' "$ROWS" | {
    i=0
    while IFS='|' read -r value process; do
        sketchybar --add item "$NAME.process.$i" popup."$NAME" \
            --set "$NAME.process.$i" icon.font="Cousine Nerd Font:Bold:14.0" icon="$value" \
                icon.width="$VALUE_WIDTH" icon.align=right \
                label="$process" label.padding_left=12 label.width="$NAME_WIDTH"
        i=$((i + 1))
    done
}

sketchybar --set "$NAME" popup.drawing=on
