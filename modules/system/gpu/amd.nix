{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.system.amd;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.modules.system.amd.enable = mkEnableOption "amd";
  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    environment.sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.libGL}/lib";
    };
  };
}
