{ config, pkgs, lib, inputs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
