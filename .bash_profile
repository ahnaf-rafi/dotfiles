#!/usr/bin/env bash
# .bash_profile

# Get the aliases, exports and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -z "${WAYLAND_DISPLAY:-}" ] && [ "${XDG_VTNR:-}" = "1" ]; then
    if command -v sway >/dev/null 2>&1; then
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=sway
        export XDG_SESSION_DESKTOP=sway

        # Create a variable to hold extra launch flags
        SWAY_FLAGS=""

        # Check if an NVIDIA GPU is present
        if lspci | grep -iE 'vga|3d|display' | grep -iq nvidia; then
            # Core graphics backends
            export GBM_BACKEND=nvidia-drm
            export __GLX_VENDOR_LIBRARY_NAME=nvidia

            # Video acceleration
            export LIBVA_DRIVER_NAME=nvidia

            # Force wayland for native toolkits.
            export MOZ_ENABLE_WAYLAND=1
            export QT_QPA_PLATFORM=wayland
            export GDK_BACKEND=wayland

            # Fix invisible or flickering cursor
            export WLR_NO_HARDWARE_CURSORS=1

            # Add the mandatory flag for NVIDIA
            SWAY_FLAGS="--unsupported-gpu"
        fi
        exec sway $SWAY_FLAGS
    else
        printf 'sway was not found in PATH\n' >&2
    fi
fi
