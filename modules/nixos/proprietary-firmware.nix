{ config, pkgs, lib, inputs, ... }:

{
  # Include proprietary firmware for Wi-Fi, Bluetooth, etc.
  hardware.enableRedistributableFirmware = true;
}
