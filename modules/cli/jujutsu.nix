{
  pkgs,
  config,
  lib,
  ...
}: let
  username = config.modules.system.username;
  cfg = config.modules.programs.jujutsu;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.programs.jujutsu.enable = mkEnableOption "jujutsu";
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.jujutsu = {
        enable = true;
        settings = {
          ui.default-command = "log";
        };
      };
    };
  };
}
