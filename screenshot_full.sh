#!/bin/bash

DIR="/mnt/hgfs/notes/screenshots"
mkdir -p "$DIR"

n=$(ls "$DIR" 2>/dev/null | grep -Eo '^img[0-9]+\.png$' | sed 's/[^0-9]//g' | sort -n | tail -1)
[ -z "$n" ] && n=0
next=$((n+1))

IMG="$DIR/img$next.png"

flameshot full -p "$IMG" && \
xclip -selection clipboard -t image/png -i "$IMG" && \
notify-send "📸 Captura completa" "Guardada como img$next.png"
