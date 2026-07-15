{ config, pkgs, lib, inputs, ... }:

let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;

    # zoom-us is unfree. This separately imported package set needs
    # its own nixpkgs configuration.
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = with pkgs; [
    kitty
    dropbox
    proton-vpn
    zathura
    goldendict-ng

    # Unstable packages
    pkgsUnstable.zoom-us
  ];
}
