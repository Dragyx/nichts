{
  config,
  lib,
  system,
  inputs,
  ...
}: let
  cfg = config.modules.WM.quickshell;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.WM.quickshell = {
    enable = mkEnableOption "quickshell";
    bar.enable = mkEnableOption "bar";
  };

  config =
    mkIf cfg.enable {
      environment.systemPackages = [
        inputs.quickshell.packages.${system}.default
      ];
    }
    // mkIf (cfg.bar.enable && cfg.bar.enable) {
    };
}
