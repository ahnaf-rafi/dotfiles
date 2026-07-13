{ config, pkgs, lib, ... }:

{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    mission-center
    wl-clipboard
    kanshi
    grim
    flameshot
    google-chrome
    libreoffice
  ];
}
