{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.git;
  username = config.modules.system.username;
in {
  options.modules.programs.git = {
    enable = mkEnableOption "git";
    userName = mkOption {
      type = types.str;
      description = "git username";
    };
    userEmail = mkOption {
      type = types.str;
      description = "git email";
    };
    #        signingKey = mkOption {
    #           type = types.str;
    #          description = "git commit signing key";
    #     };
    editor = mkOption {
      type = types.str;
      default = "$EDITOR";
      description = "commit message editor";
    };
    defaultBranch = mkOption {
      type = types.str;
      default = "master";
      description = "default git branch";
    };
    pullRebase = mkOption {
      type = types.bool;
      default = false;
      description = "git config pull.rebase {pullRebase}";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.git = {
        inherit (cfg) enable userName userEmail;
        extraConfig = {
          /*
             currently broken (rust compile error)
          core = {
              editor = cfg.editor;
              pager = "${pkgs.delta}/bin/delta";
          };
          */
          init.defaultBranch = cfg.defaultBranch;
          push.autoSetupRemote = true;
          commit = {
            verbose = true;
            # gpgsign = true;
          };
          # gpg.format = "ssh";
          #                    user.signingkey = "key::${cfg.signingKey}";
          merge.conflictstyle = "zdiff3";
          # currently broken: interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
          diff.algorithm = "histogram";
          transfer.fsckobjects = true;
          fetch.fsckobjects = true;
          receive.fsckobjects = true;
          pull.rebase = cfg.pullRebase;
        };
      };
    };
  };
}
