{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # Overlays
    ../../modules/common/nixpkgs-overlays.nix
    # Nix settings
    ../../modules/common/nix-settings.nix
    # Boot setup
    ../../modules/nixos/boot.nix
    # Allow proprietary firmware
    ../../modules/nixos/proprietary-firmware.nix
    # Nvidia
    ../../modules/nixos/nvidia.nix
    # Bluetooth setup
    ../../modules/nixos/bluetooth.nix
    # Audio
    ../../modules/nixos/audio.nix
    # Window management
    ../../modules/nixos/sway.nix
    # User setup
    ../../modules/nixos/user-ahnaf.nix
    # Use nix-ld
    ../../modules/nixos/nix-ld.nix
    # Enable ssh
    ../../modules/common/ssh.nix
    # Fonts
    ../../modules/common/fonts.nix
    # Core cli packages and configs
    ../../modules/common/core-cli-pkgs.nix
    # Core gui packages and configs
    ../../modules/common/core-gui-pkgs.nix
    # Extra package configs
    ../../modules/common/tex.nix
    ../../modules/common/R.nix
    ../../modules/common/RStudio.nix
    ../../modules/common/julia.nix
    ../../modules/common/emacs.nix
    ../../modules/nixos/emacsclient.nix
  ];

  #------------#
  # Networking #
  #------------#
  # Hostname.
  networking.hostName = "nigel";

  # Use NetworkManager (nmcli or nmtui) for configuring network connections.
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  #--------------------------------#
  # Extras for sway window manager #
  #--------------------------------#

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";

    # Essential for Sway to not crash with the proprietary NVIDIA driver.
    WLR_NO_HARDWARE_CURSORS = "1";

    # With Sway 1.12+, this silences NVIDIA warning.
    SWAY_UNSUPPORTED_GPU = "1";
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application
  # data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any
  # reason, even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are
  # pulled from, so changing it will NOT upgrade your system - see
  # https://nixos.org/manual/nixos/stable/#sec-upgrading for how to actually do
  # that.
  #
  # This value being lower than the current NixOS release does NOT mean your
  # system is out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes
  # it would make to your configuration, and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
