#!/usr/bin/env bash

# Assign arguments to readable variables
RIGHT_MONITOR="$1"
LEFT_MONITOR="$2"

# Map workspaces 1-10 to the right monitor
for i in {1..10}; do
    swaymsg workspace "$i" output \""$RIGHT_MONITOR"\"
done

# Map workspaces 11-20 to the left monitor
for i in {11..20}; do
    swaymsg workspace "$i" output \""$LEFT_MONITOR"\"
done

swaymsg 'workspace 11; workspace 1'
