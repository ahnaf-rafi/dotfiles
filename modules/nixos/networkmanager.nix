{ config, pkgs, lib, ...}:

{
  # Use NetworkManager (nmcli or nmtui) for configuring network connections.
  networking.networkmanager = {
    enable = true;
    wifi.backend = "wpa_supplicant";
  };
  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
