{ pkgs, ... }:

let
  rPkgs = import ./R-pkglist.nix { inherit pkgs; };

  RStudio-with-packages = pkgs.rstudioWrapper.override {
    packages = rPkgs;
  };
in
{
  environment.systemPackages = [
    RStudio-with-packages
  ];
}
