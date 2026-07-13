{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    hunspell
    hunspellDicts.en_US-large
  ];
}
