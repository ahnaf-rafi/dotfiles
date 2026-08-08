#!/usr/bin/env bash
# .bash_profile

# Get the aliases, exports and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
    # # Check if an NVIDIA GPU is present
    # if lspci | grep -iE 'vga|3d|display' | grep -iq nvidia; then
    #     export LIBVA_DRIVER_NAME="nvidia"
    #     export __GLX_VENDOR_LIBRARY_NAME="nvidia"
    # fi
    start-hyprland
fi
