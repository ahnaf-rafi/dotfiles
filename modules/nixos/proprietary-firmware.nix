{ config, pkgs, lib, ... }:

{
  # Include proprietary firmware for Wi-Fi, Bluetooth, etc.
  hardware.enableRedistributableFirmware = true;
}
