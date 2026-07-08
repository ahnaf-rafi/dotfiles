{ pkgs, ... }:

let
  myEmacs = import ../common/emacs-package.nix { inherit pkgs; };
in
{
  services.emacs = {
    enable = true;
    package = myEmacs;
    # Useful for Sway/graphical sessions. Without this, emacsclient may not be
    # able to create graphical frames.
    startWithGraphical = true;
  };
}
