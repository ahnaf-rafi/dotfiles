{ pkgs, ... }:

let
  rPkgs = import ./R-pkglist.nix { inherit pkgs; };

  R-with-packages = pkgs.rWrapper.override {
    packages = rPkgs;
  };
in
{
  environment.systemPackages = [
    R-with-packages
  ];
}
