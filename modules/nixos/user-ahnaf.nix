{ config, pkgs, lib, inputs, ... }:

{
  users.users.ahnaf = {
    isNormalUser = true;
    shell = pkgs.bashInteractive;
    extraGroups = [ "wheel" "networkmanager" ];
    # packages = with pkgs; [ ];
  };
}
