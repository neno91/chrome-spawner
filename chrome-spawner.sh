#!/bin/bash

read -p "Enter address: " URL
URL=${URL:-http://localhost}

read -p "How many browsers to open? " COUNT
COUNT=${COUNT:-1}

for i in $(seq 1 $COUNT); do
    PROFILE_DIR=$(mktemp -d "/tmp/chrome_profile_${i}_XXXXXX")
    open -na "Google Chrome" --args --new-window --user-data-dir="$PROFILE_DIR" --no-first-run --no-default-browser-check --disable-search-engine-choice-screen "$URL"
done

echo "Waiting for browsers to start..."
sleep 3

osascript -e "
tell application \"System Events\"
    set chromeWindows to every window of application process \"Google Chrome\"
    set n to $COUNT
    set cols to (n ^ 0.5) div 1
    if cols * cols < n then set cols to cols + 1
    set rows to ((n + cols - 1) / cols) div 1

    tell application \"Finder\"
        set screenBounds to bounds of window of desktop
        set sw to item 3 of screenBounds
        set sh to item 4 of screenBounds - 25
    end tell

    set w to sw div cols
    set h to sh div rows
    set i to 0

    repeat with win in chromeWindows
        if i ≥ n then exit repeat
        set col to i mod cols
        set row to i div cols
        set x to col * w
        set y to row * h + 25
        set position of win to {x, y}
        set size of win to {w, h}
        set i to i + 1
    end repeat
end tell
"

echo "Done! Arranged $COUNT browsers in a grid."
