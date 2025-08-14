{
  lib,
  config,
  ...
}: let
  username = config.modules.system.username;
  cfg = config.modules.programs.carapace;
  inherit (lib) mkIf mkEnableOption;
in {
  options.modules.programs.carapace.enable = mkEnableOption "carapace";
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.carapace = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
