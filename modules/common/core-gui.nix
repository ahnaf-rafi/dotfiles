{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # GUI software
    kitty
    dropbox
    zoom-us
    proton-vpn
    zathura
    goldendict-ng
  ];
}
