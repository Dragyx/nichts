{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.programs.starship;
  username = config.modules.system.username;
in {
  options.modules.programs.starship.enable = mkEnableOption "starship";

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.starship = {
        enable = true;
        enableZshIntegration = config.modules.programs.zsh.enable;
        settings = {
          git_status.disabled = true; # makes everything slow when jj is in use
          git_commit.disabled = true;
          git_metrics.disabled = true;
          git_branch.disabled = true;
          format = ''
            $all''${custom.git_branch}''${custom.git_commit}''${custom.git_metrics}''${custom.git_status}
          '';
          # taken from https://github.com/jj-vcs/jj/wiki/Starship
          custom = {
            # custom module for jj status
            # note that you'll need to add ${custom.git_branch}, ${custom.git_commit} etc
            # into format: https://starship.rs/config/#default-prompt-format
            jj = {
              description = "The current jj status";
              when = "jj --ignore-working-copy root";
              symbol = "🥋 ";
              command = ''
                jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
                  separate(" ",
                    change_id.shortest(4),
                    bookmarks,
                    "|",
                    concat(
                      if(conflict, "💥"),
                      if(divergent, "🚧"),
                      if(hidden, "👻"),
                      if(immutable, "🔒"),
                    ),
                    raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
                    raw_escape_sequence("\x1b[1;32m") ++ coalesce(
                      truncate_end(29, description.first_line(), "…"),
                      "∅",
                    ) ++ raw_escape_sequence("\x1b[0m"),
                  )
                '
              '';
            };

            git_status = {
              when = "! jj --ignore-working-copy root";
              command = "starship module git_status";
              style = ""; # This disables the default "(bold green)" style
              description = "Only show git_status if we're not in a jj repo";
            };
            git_commit = {
              when = "! jj --ignore-working-copy root";
              command = "starship module git_commit";
              style = "";
              description = "Only show git_commit if we're not in a jj repo";
            };
            git_metrics = {
              when = "! jj --ignore-working-copy root";
              command = "starship module git_metrics";
              description = "Only show git_metrics if we're not in a jj repo";
              style = "";
            };
            git_branch = {
              when = "! jj --ignore-working-copy root";
              command = "starship module git_branch";
              description = "Only show git_branch if we're not in a jj repo";
              style = "";
            };
          };
          add_newline = false;
          command_timeout = 1000;
          line_break = {
            disabled = true;
          };
          directory = {
            truncation_length = 3;
            truncate_to_repo = false;
            truncation_symbol = "…/";
          };
          c.symbol = " ";
          directory.read_only = " 󰌾";
          git_branch.symbol = " ";
          haskell.symbol = " ";
          hostname.ssh_symbol = " ";
          java.symbol = " ";
          kotlin.symbol = " ";
          meson.symbol = "󰔷 ";
          nix_shell.symbol = " ";
          package.symbol = "󰏗 ";
          rust.symbol = " ";
        };
      };
    };
  };
}
