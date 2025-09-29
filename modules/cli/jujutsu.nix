{
  pkgs,
  config,
  lib,
  ...
}: let
  username = config.modules.system.username;
  cfg = config.modules.programs.jujutsu;
  inherit (lib) mkEnableOption mkIf getExe;
in {
  options.modules.programs.jujutsu.enable = mkEnableOption "jujutsu";
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.jujutsu = {
        enable = true;
        settings = {
          ui = {
            default-command = "log";
            pager = "${getExe pkgs.delta}";
          };
          "--scope" = [
            {
              "--when"."commands" = [
                "status"
                "log"
              ];
              ui = {
                paginate = "never";
              };
            }
          ];
          aliases = {
            # Inspired by https://copeberg.org/faukah/nichts/src/branch/main/modules/programs/cli/jujutsu.mod.nix
            tug = [
              "bookmark"
              "move"
              "-f"
              "heads(::@- & bookmarks())"
              "-t"
              "@-"
            ];
          };
        };
      };
    };
  };
}
