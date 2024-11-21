{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.editors.helix;
  inherit (config.modules.system) username;
  inherit (lib) mkIf mkEnableOption getExe mkOption types;
in {
  # this config (including languages.nix was largely taken from https://github.com/bloxx12/nichts)
  options.modules.programs.editors.helix = {
    enable = mkEnableOption "helix";
    default = mkOption {
      description = "Try to make helix the default editor (in shell etc)";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable
    {
    environment.variables.EDITOR = mkIf cfg.default "hx"; # getExe config.home-manager.users.${username}.programs.helix.package;
      home-manager.users.${username} = {
        programs.helix = {
          enable = true;
          package = inputs.helix.packages.${pkgs.system}.default;

          settings = {
            editor = {
              cursorline = true;
              color-modes = true;
              indent-guides.render = true;
              lsp.display-inlay-hints = true;
              line-number = "relative";
              true-color = true;
              auto-format = true;
              completion-timeout = 5;
              mouse = true;
              bufferline = "multiple";
              soft-wrap.enable = true;
              lsp.display-messages = true;
              cursor-shape = {insert = "bar";};
              statusline.left = ["spinner" "version-control" "file-name"];
              /*
              inline-diagnostics = {
                cursor-line = "hint";
                other-lines = "error";
              };
              */
            };
            keys.normal = {
              "space".g = [":new" ":insert-output ${getExe pkgs.lazygit}" ":buffer-close!" ":redraw"];
              esc = ["collapse_selection" "keep_primary_selection"];
              A-H = ":bn";
              A-L = ":bp";
              A-w = ":buffer-close";
              A-f = ":format";
            };
          };
        };
      };
    }
  ;
}
