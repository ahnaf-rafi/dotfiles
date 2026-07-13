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
    # Network manager setup
    ../../modules/nixos/networkmanager.nix
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
    # Common core cli packages and configs
    ../../modules/common/core-cli.nix
    # Common core gui packages and configs
    ../../modules/common/core-gui.nix
    # NixOS-specific core gui packages and configs
    ../../modules/nixos/core-gui.nix
    # Extra package configs
    ../../modules/common/hunspell.nix
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
  networking.hostName = "leonard";

  # Use NetworkManager (nmcli or nmtui) for configuring network connections.
  networking.networkmanager = {
    enable = true;
    wifi.backend = "wpa_supplicant";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";
}
