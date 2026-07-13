{ config, pkgs, lib, inputs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    julia-mono
  ];
}
