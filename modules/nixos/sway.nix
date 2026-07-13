{ config, pkgs, lib, ... }:

{

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  programs.sway = {
    enable = true;
    xwayland.enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      foot
      waybar
      rofi
      xdg-desktop-portal-wlr
      mako
    ];
  };

}
