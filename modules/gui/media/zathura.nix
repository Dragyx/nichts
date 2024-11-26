{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.programs.zathura;
  username = config.modules.system.username;
in {
  options.modules.programs.zathura.enable = mkEnableOption "zathura";

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.zathura = {
        enable = true;
        options = {
          selection-clipboard = "clipboard";
        };
      };
    };
  };
}
