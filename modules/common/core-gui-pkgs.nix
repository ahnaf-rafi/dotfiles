{ config, pkgs, lib, ... }:

{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    # GUI software
    kitty
    mission-center
    dropbox
    wl-clipboard
    kanshi
    grim
    flameshot
    google-chrome
    zoom-us
    proton-vpn
    zathura
    libreoffice
    hunspell
    hunspellDicts.en_US-large
    goldendict-ng
  ];
}
