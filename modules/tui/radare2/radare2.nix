{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.modules.system) username;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.programs.radare2;
in {
  options.modules.programs.radare2.enable = mkEnableOption "radare2";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.radare2];
    home-manager.users.${username}.xdg.configFile."radare2/radare2rc" = {
      enable = true;
      text = builtins.readFile ./radare2rc;
    };
  };
}
