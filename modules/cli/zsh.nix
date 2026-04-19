{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.zsh;
  username = config.modules.system.username;
  gitPath = config.modules.system.gitPath;
in
{
  options.modules.programs.zsh = {
    enable = mkEnableOption "zsh";
    extraAliases = mkOption {
      type = types.attrs;
      description = "extra shell aliases";
      default = { };
    };
    profiling = mkOption {
      type = types.bool;
      description = "enable zsh profiling";
      default = false;
    };
    ohmyzsh = {
      enable = mkEnableOption "ohmyzsh";
      theme = mkOption {
        type = types.str;
        description = "oh-my-zsh theme";
        default = "alanpeabody";
      };
      plugins = mkOption {
        type = types.listOf (types.str);
        description = "oh-my-zsh plugins (like git)";
        default = [ "git" ];
      };
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    #        users.users.${username}.shell = pkgs.zsh;
    environment = {
      shells = [ pkgs.zsh ];
      pathsToLink = [ "/share/zsh" ];
    };
    systemd.services.nitch-cached = {
      description = "Caches nitch output to /home/${username}/.cache/nitch.cached";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "root";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.sudo}/bin/sudo -u ${username} ${pkgs.nitch}/bin/nitch > /home/${username}/.cache/nitch.cached'";
        WorkingDirectory = "/home/${username}/.cache";
      };
    };
    systemd.timers."nitch-cached" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1s";
        OnUnitActiveSec = "1m";
        Unit = "nitch-cached.service";
      };
    };
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        nix-output-monitor
        nitch
      ];
      programs.zoxide.enable = true;
      programs.zoxide.enableZshIntegration = true;
      programs.zsh = {
        enable = true;
        shellAliases = {
          mv = "mv -i";
          # rm = "trash -v";
          ls = "eza";
          l = "eza -a --icons";
          la = "eza -lha --icons --git";
          ll = "eza -l";
          kys = "shutdown now";
          cd = "z";
          nv = "nvim";
          rebuild = "nh os switch";
          flake = "cd '${gitPath}'";
        }
        // cfg.extraAliases;
        initExtraFirst = mkIf cfg.profiling "zmodload zsh/zprof";
        initExtra = lib.strings.concatStrings (
          [
            "\nif [ -f /home/${username}/.cache/nitch.cached ]; then cat /home/${username}/.cache/nitch.cached; fi"
          ]
          ++ (if cfg.profiling then [ "\nzprof" ] else [ "" ])
        );
        history = {
          path = "${config.home-manager.users.${username}.xdg.dataHome}/zsh/zsh_history";
          size = 99999;
          save = 99999;
          extended = true;
          ignoreSpace = true;
        };
        autosuggestion.enable = true;
        enableCompletion = true;
        autocd = false;
        dotDir = ".config/zsh";
        /*
            plugins = [
            {
                name = "fast-syntax-highlighting";
                file = "fast-syntax-highlighting.plugin.zsh";
                src = pkgs.fetchFromGitHub {
                  owner = "zdharma-continuum";
                  repo = "fast-syntax-highlighting";
                  rev = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9";
                  sha256 = "sha256-RVX9ZSzjBW3LpFs2W86lKI6vtcvDWP6EPxzeTcRZua4=";
                };
            }
          ];
        */
        oh-my-zsh = mkIf cfg.ohmyzsh.enable {
          enable = true;
          theme = cfg.ohmyzsh.theme;
          plugins = cfg.ohmyzsh.plugins;
        };
      };
    };
  };
}
