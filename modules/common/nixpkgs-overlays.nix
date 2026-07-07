{ config, pkgs, lib, inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlays.default
  ];
}
