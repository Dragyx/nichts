{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.cosmic;
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.modules.cosmic.enable = mkEnableOption "cosmic";
  options.modules.cosmic.greeter.enable = mkEnableOption "greeter";

  config = mkMerge [
    (mkIf cfg.enable {
      services.desktopManager = {
        cosmic.enable = true;
      };
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-cosmic
          pkgs.xdg-desktop-portal-gtk
        ];
        config.common = {
          default = "cosmic;gtk";
          "org.freedesktop.impl.portal.AppChooser" = "gtk";
        };
        config.cosmic = {
          default = "cosmic;gtk";
          "org.freedesktop.impl.portal.AppChooser" = "gtk";
        };
      };
    })
    (mkIf cfg.greeter.enable {
      services.displayManager = {
        cosmic-greeter.enable = true;
      };
    })
  ];
}
