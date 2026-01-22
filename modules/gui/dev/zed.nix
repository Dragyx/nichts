{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.modules.programs.zed;
  user = config.modules.system.username;
in
{
  options.modules.programs.zed.enable = mkEnableOption "zed";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rust-analyzer
      nixd
    ];
    home-manager.users.${user} = {
      programs.zed-editor = {
        enable = true;
        userSettings = {
          agent = {
            default_model = {
              provider = "copilot_chat";
              model = "claude-sonnet-4.5";
            };
            favorite_models = [ ];
            model_parameters = [ ];
          };
          completions = {
            words = "enabled";
            words_min_length = 1;
          };

          tab_size = 2;
          helix_mode = true;
          ui_font_size = 16;
          buffer_font_size = 15;
          theme = {
            mode = "system";
            light = mkForce "One Light";
            dark = mkForce "One Dark";
          };
        };
      };
    };
  };
}
