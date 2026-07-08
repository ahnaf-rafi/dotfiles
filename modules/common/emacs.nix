{ pkgs, ... }:

let
  myEmacs = import ./emacs-package.nix { inherit pkgs; };
in
{
  environment.systemPackages = [ myEmacs ];
}
