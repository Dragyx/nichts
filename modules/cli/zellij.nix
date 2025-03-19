{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.programs.zellij;
  inherit (config.modules.system) username;
  inherit (lib) mkIf mkEnableOption getExe;
in {
  options.modules.programs.zellij.enable = mkEnableOption "zellij";
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.zellij = {
        enable = true;
        # enableFishIntegration = true;
        settings = {
          #$ on_force_close = "quit";
          show_startup_tips = false;
          pane_frames = false;
          default_layout = "compact";
          ui = {
            pane_frames = {
              # hide_session_name = true;
              rounded_corners = true;
            };
          };
          plugins = {
            tab-bar.path = "tab-bar";
            status-bar.path = "status-bar";
            strider.path = "strider";
            compact-bar.path = "compact-bar";
          };
        };
      };
      # TODO: move this somewhere else
      programs.foot.settings.main.shell = "${getExe pkgs.zellij}";
    };
  };
}
