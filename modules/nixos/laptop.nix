{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services.thermald.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      START_CHARGE_THRESH_BAT0 = 75; # Starts charging below this threshold.
      STOP_CHARGE_THRESH_BAT0 = 80;  # Stops charging above this threshold.

      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 1;
    };
  };
}
