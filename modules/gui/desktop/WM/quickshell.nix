{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.WM.quickshell;
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (pkgs) system;
in {
  options.modules.WM.quickshell = {
    enable = mkEnableOption "quickshell";
    bar.enable = mkEnableOption "bar";
  };

  config = mkMerge [
    (mkIf
      cfg.enable
      {
        environment.systemPackages = [
          # (inputs.quickshell.packages.${system}.default.override {
          #   withQtSvg = true;
          #   withPipewire = true;
          #   withPam = true;
          #   withHyprland = true;
          # })
        ];
      })
    (mkIf
      (cfg.enable && cfg.bar.enable)
      {
      })
  ];
}
