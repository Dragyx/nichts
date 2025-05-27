{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.modules.system) username;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.programs.codium;
in {
  options.modules.programs.codium = {
    enable = mkEnableOption "codium";
  };
  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs; [
        # vscode-extensions.rust-lang.rust-analyzer
        # vscode-extensions.gruntfuggly.todo-tree
        # vscode-extensions.ms-python.python
        # vscode-extensions.eamodio.gitlens
        # vscode-extensions.angular.ng-template
        # vscode-extensions.asciidoctor.asciidoctor-vscode
        # vscode-extensions.bbenoist.nix
        # vscode-extensions.viper-admin.viper
      ];
      userSettings = {
        "editor.fontFamily" = "JetBrainsMono Nerd Font";
        "editor.fontLigatures" = true;
        "telemetry.telemetryLevel" = "off";
        "rust-analyzer.checkOnSave.command" = "clippy";
        "terminal.integrated.profiles.linux" = {
          "fish" = {
            "path" = "fish";
          };
          "bash" = {
            "path" = "bash";
            "icon" = "terminal-bash";
          };
        };
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.external.linuxExec" = "footclient";
        "viperSettings.verificationBackends" = [
          {
            "v" = "674a514867b1";
            "name" = "silicon";
            "type" = "silicon";
            "paths" = [];
            "engine" = "ViperServer";
            "timeout" = 100000;
            "stages" = [
              {
                "name" = "verify";
                "isVerification" = true;
                "mainMethod" = "viper.silicon.SiliconRunner";
                "customArguments" = "--submitForEvaluation --z3Exe $z3Exe$ $disableCaching$ $fileToVerify$";
              }
            ];
            "stoppingTimeout" = 5000;
          }
          {
            "v" = "674a514867b1";
            "name" = "carbon";
            "type" = "carbon";
            "paths" = [];
            "engine" = "ViperServer";
            "timeout" = 100000;
            "stages" = [
              {
                "name" = "verify";
                "isVerification" = true;
                "mainMethod" = "viper.carbon.Carbon";
                "customArguments" = "--submitForEvaluation --z3Exe $z3Exe$ --boogieExe $boogieExe$ $disableCaching$ $fileToVerify$";
              }
            ];
            "stoppingTimeout" = 5000;
          }
        ];
      };
    };
  };
}
