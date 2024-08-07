{
    config,
    lib,
    pkgs,
    ...
}: with lib; let
    cfg = config.modules.programs.atuin;
    username = config.modules.other.system.username;
in {

  options.modules.programs.atuin.enable = mkEnableOption "atuin";

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.atuin = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };



}
