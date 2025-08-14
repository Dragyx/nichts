{
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.system.watt;
  inherit (lib) mkIf mkEnableOption;
in {
  imports = [
    inputs.watt.nixosModules.default
  ];
  options.modules.system.watt.enable = mkEnableOption "watt";
  config = mkIf cfg.enable {
    services.power-profiles-daemon.enable = false;
    services.watt = {
      enable = true;
      settings = {
        charger = {
          # CPU governor to use
          governor = "performance";
          # Turbo boost setting: "always", "auto", or "never"
          turbo = "auto";
          # Energy Performance Preference
          epp = "performance";
          # Energy Performance Bias (0-15 scale or named value)
          epb = "balance_performance";
          # Platform profile (if supported)
          platform_profile = "performance";
        };
        battery = {
          governor = "powersave";
          turbo = "auto";
          epp = "power";
          epb = "balance_power";
          platform_profile = "low-power";
        };
      };
    };
  };
}
