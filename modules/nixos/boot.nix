{ config, pkgs, lib, inputs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Show three generations: 3 gens plus option to reboot to firmware.
  boot.loader.systemd-boot.configurationLimit = 4;
}
