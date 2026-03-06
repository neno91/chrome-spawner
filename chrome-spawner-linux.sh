#!/bin/bash

read -p "Enter address: " URL
URL=${URL:-http://localhost}

read -p "How many browsers to open? " COUNT
COUNT=${COUNT:-1}

# Detect Chrome binary
CHROME=""
for bin in google-chrome google-chrome-stable chromium-browser chromium; do
    if command -v "$bin" &>/dev/null; then
        CHROME="$bin"
        break
    fi
done

if [ -z "$CHROME" ]; then
    echo "Error: Chrome/Chromium not found."
    exit 1
fi

PIDS=()
for i in $(seq 1 $COUNT); do
    PROFILE_DIR=$(mktemp -d "/tmp/chrome_profile_${i}_XXXXXX")
    $CHROME --new-window --user-data-dir="$PROFILE_DIR" --no-first-run --no-default-browser-check --disable-search-engine-choice-screen "$URL" &
    PIDS+=($!)
done

echo "Waiting for browsers to start..."
sleep 3

if ! command -v xdotool &>/dev/null; then
    echo "Install xdotool to auto-arrange windows: sudo apt install xdotool"
    exit 0
fi

SCREEN_W=$(xdpyinfo | grep dimensions | awk '{print $2}' | cut -d'x' -f1)
SCREEN_H=$(xdpyinfo | grep dimensions | awk '{print $2}' | cut -d'x' -f2)

COLS=$(echo "scale=0; c=sqrt($COUNT); if(c*c<$COUNT) c+1 else c" | bc)
ROWS=$(echo "scale=0; ($COUNT + $COLS - 1) / $COLS" | bc)
W=$((SCREEN_W / COLS))
H=$((SCREEN_H / ROWS))

WINDOWS=$(xdotool search --name "Chrome" 2>/dev/null | tail -n "$COUNT")

i=0
for WID in $WINDOWS; do
    if [ $i -ge $COUNT ]; then break; fi
    COL=$((i % COLS))
    ROW=$((i / COLS))
    X=$((COL * W))
    Y=$((ROW * H))
    xdotool windowactivate "$WID" windowmove "$WID" "$X" "$Y" windowsize "$WID" "$W" "$H"
    i=$((i + 1))
done

echo "Done! Arranged $COUNT browsers in a grid."
