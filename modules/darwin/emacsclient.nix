{ pkgs, ... }:

let
  myEmacs = import ./emacs-package.nix { inherit pkgs; };
in
{
  launchd.user.agents.emacs = {
    command = "${emacsBin} --fg-daemon";

    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;

      StandardOutPath = "/tmp/emacs-daemon.out.log";
      StandardErrorPath = "/tmp/emacs-daemon.err.log";
    };
  };
}
