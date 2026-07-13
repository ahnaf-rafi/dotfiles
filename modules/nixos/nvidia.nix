{ config, pkgs, lib, ... }:

{
  # Enable graphics support (replaces hardware.opengl in newer NixOS versions)
  hardware.graphics.enable = true;

  # Tell X11/Wayland to use the nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is needed to fix TTY hang and is required for Wayland.
    modesetting.enable = true;

    # Use the open source driver for newer Nvidia architectures.
    open = true;

    # Enable the NVIDIA settings menu
    nvidiaSettings = true;

    # Select the appropriate driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
