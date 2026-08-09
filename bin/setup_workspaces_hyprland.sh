#!/usr/bin/env bash

# Assign arguments to readable variables
LEFT_MONITOR="$1"
RIGHT_MONITOR="$2"

# Map workspaces 1-10 to the right monitor
for i in {1..10}; do
    hyprctl keyword workspace "$i, monitor:desc:$RIGHT_MONITOR"
done

# Map workspaces 11-20 to the left monitor
for i in {11..20}; do
    hyprctl keyword workspace "$i, monitor:desc:$LEFT_MONITOR"
done

# Focus workspace 11, then focus workspace 1
hyprctl dispatch workspace 11
hyprctl dispatch workspace 1
