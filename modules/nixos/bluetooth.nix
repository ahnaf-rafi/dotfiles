{ config, pkgs, lib, inputs, ...}:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;
}
