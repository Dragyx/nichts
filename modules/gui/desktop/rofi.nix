{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  username = config.modules.system.username;
  cfg = config.modules.programs.rofi;
in {
  options.modules.programs.rofi.enable = mkEnableOption "rofi";
  options.modules.system.wayland = mkOption {
    type = types.bool;
    description = "Does this system use wayland?";
    default = false;
  }; #FIXME: move this to the (hopefully then) refactored options directory

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.rofi
    ];
    home-manager.users.${username} = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi;
      };
    };
  };
}
