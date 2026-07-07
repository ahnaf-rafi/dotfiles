# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Allow proprietary packages (needed for most Wi-Fi firmware)
  nixpkgs.config.allowUnfree = true;

  # Keep up to three generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options =  "--delete-older-than +3";
  };

  # Include proprietary firmware for Wi-Fi, Bluetooth, etc.
  hardware.enableRedistributableFirmware = true;

  # Boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Show only three generations
  boot.loader.systemd-boot.configurationLimit = 3;

  # Hostname.
  networking.hostName = "nigel";

  # Use NetworkManager (nmcli or nmtui) for configuring network connections.
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Configure keymap in X11.
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Nix settings.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ================================= #
  # Graphics and NVIDIA Configuration #
  # ================================= #

  # Enable graphics support (replaces hardware.opengl in newer NixOS versions)
  hardware.graphics.enable = true;

  # Tell X11/Wayland to use the nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is needed to fix TTY hang and is required for Wayland.
    modesetting.enable = true;

    # Set to false to use the proprietary closed-source driver, which is
    # currently the most stable option.
    open = true;

    # Enable the NVIDIA settings menu
    nvidiaSettings = true;

    # Select the appropriate driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Packages.
  programs.firefox.enable = true;
  programs.bash.enable = true;
  programs.sway ={
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

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    kitty
    stow
    wl-clipboard
    grim
    flameshot
    fd
    ripgrep
    delta
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";

    # Only uncomment if the cursor is invisible/flickery.
    # WLR_NO_HARDWARE_CURSORS = "1";

    # W
    SWAY_UNSUPPORTED_GPU = "1";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    julia-mono
  ];

  # Services to be enabled.

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # User account. Don't forget to set a password with ‘passwd’.
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
