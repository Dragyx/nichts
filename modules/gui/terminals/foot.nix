{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.foot;
  username = config.modules.system.username;
  inherit (lib) mkEnableOption mkIf getExe;
in {
  options.modules.programs.foot = {
    enable = mkEnableOption "foot";
    server = mkEnableOption "foot server mode";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      TERM = "foot";
    };
    home-manager.users.${username} = {
      programs.foot = {
        enable = true;
        server.enable = cfg.server;
        settings = {
          main = {
            dpi-aware = "yes";
            shell = "fish -C '${getExe pkgs.microfetch}'";
          };
        };
      };
    };
  };
}
