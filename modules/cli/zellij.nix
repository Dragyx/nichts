{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.programs.zellij;
  inherit (config.modules.system) username;
in {
  options.modules.programs.zellij.enable = lib.mkEnableOption "zellij";
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.zellij = {
        enable = true;
        # enableFishIntegration = true;
        settings = {
          #$ on_force_close = "quit";
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
      programs.foot.settings.main.shell = "${pkgs.zellij}/bin/zellij";
    };
  };
}
