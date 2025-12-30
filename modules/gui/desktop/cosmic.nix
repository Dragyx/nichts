{
  config,
  lib,
  ...
}: let
  cfg = config.modules.cosmic;
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.modules.cosmic.enable = mkEnableOption "cosmic";
  options.modules.cosmic.greeter.enable = mkEnableOption "greeter";

  config = mkMerge [
    (mkIf
      cfg.enable
      {
        services.desktopManager = {
          cosmic.enable = true;
        };
      })
    (mkIf
      cfg.greeter.enable
      {
        services.displayManager = {
          cosmic-greeter.enable = true;
        };
      })
  ];
}
