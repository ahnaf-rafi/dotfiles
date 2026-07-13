{ config, pkgs, lib, inputs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Keep up to three generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options =  "--delete-older-than +3";
  };

  # Allow proprietary packages (needed for most Wi-Fi firmware)
  nixpkgs.config.allowUnfree = true;
}
