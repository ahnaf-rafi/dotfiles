#!/usr/bin/env bash
# .bash_profile

# Get the aliases, exports and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -z "${WAYLAND_DISPLAY:-}" ] && [ "${XDG_VTNR:-}" = "1" ]; then

    if command -v start-hyprland >/dev/null 2>&1; then
        # Check if an NVIDIA GPU is present
        if lspci | grep -iE 'vga|3d|display' | grep -iq nvidia; then
            export LIBVA_DRIVER_NAME="nvidia"
            export __GLX_VENDOR_LIBRARY_NAME="nvidia"
        fi
        start-hyprland
    else
        printf 'start-hyprland was not found in PATH\n' >&2
    fi
fi
