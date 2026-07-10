# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/nixpkgs-overlays.nix
    ../../modules/common/tex.nix
    ../../modules/common/R.nix
    ../../modules/common/RStudio.nix
    ../../modules/common/julia.nix
    ../../modules/common/emacs.nix
    ../../modules/nixos/emacsclient.nix
  ];

  #--------------#
  # Nix settings #
  #--------------#
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Keep up to three generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options =  "--delete-older-than +3";
  };

  # Allow proprietary packages (needed for most Wi-Fi firmware)
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  #-------------#
  # Boot loader #
  #-------------#
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Show three generations: 3 gens plus option to reboot to firmware.
  boot.loader.systemd-boot.configurationLimit = 4;

  #-------------------#
  # Hardware settings #
  #-------------------#

  # Include proprietary firmware for Wi-Fi, Bluetooth, etc.
  hardware.enableRedistributableFirmware = true;

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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

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

  #-------#
  # Audio #
  #-------#

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  # Enable pipewire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #----------------------#
  # Window manager: sway #
  #----------------------#
  programs.sway = {
    enable = true;
    xwayland.enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      foot
      waybar
      rofi
      xdg-desktop-portal-wlr
      mako
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  #----------#
  # Packages #
  #----------#
  programs.firefox.enable = true;
  programs.bash.enable = true;
  programs.neovim.enable = true;

  environment.systemPackages = with pkgs; [
    # CLI software
    vim-full
    git
    curl
    zip
    unzip
    stow
    fzf
    fd
    ripgrep
    delta
    htop
    pciutils
    rclone

    # GUI software
    kitty
    mission-center
    dropbox
    pulseaudio
    pavucontrol
    networkmanagerapplet
    wl-clipboard
    kanshi
    grim
    flameshot
    google-chrome
    proton-vpn
    zathura
    libreoffice
    hunspell
    hunspellDicts.en_US-large
    goldendict-ng
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";

    # Essential for Sway to not crash with the proprietary NVIDIA driver.
    WLR_NO_HARDWARE_CURSORS = "1";

    # With Sway 1.12+, this silences NVIDIA warning.:wq
    SWAY_UNSUPPORTED_GPU = "1";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    julia-mono
  ];

  #------------------------#
  # Services to be enabled #
  #------------------------#

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  #---------------#
  # User accounts #
  #---------------#
  # Don't forget to set a password with ‘passwd’.
  users.users.ahnaf = {
    isNormalUser = true;
    shell = pkgs.bashInteractive;
    extraGroups = [ "wheel" "networkmanager" ];
    # packages = with pkgs; [ ];
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
