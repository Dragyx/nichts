{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.displaymanager;
in {
  options.modules.programs.displaymanager.enable = mkEnableOption "displaymanager";

  config = mkIf cfg.enable {
    /*
      services.xserver.displayManager = {
      gdm.enable = true;
      defaultSession = "none+i3";
    };
    */
  };
}
