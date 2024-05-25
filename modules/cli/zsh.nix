{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.modules.programs.zsh;
  username = config.modules.other.system.username;
  hostname = config.modules.other.system.hostname;
  gitPath = config.modules.other.system.gitPath;
in {
    options.modules.programs.zsh = {
        enable = mkEnableOption "zsh";
        extraAliases = mkOption {
            type = types.attrs;
            description = "extra shell aliases";
            default = {};
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
	              type = types.listOf(types.str);
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
        home-manager.users.${username} = {
            home.packages = with pkgs; [ nix-output-monitor nitch ];
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
                    #TODO fix hardcoding of git repo path and profile name
                    rebuild = "nh os switch";
                    flake = "cd '${gitPath}'";

                } // cfg.extraAliases;
                initExtraFirst = mkIf cfg.profiling "zmodload zsh/zprof";
                initExtra = lib.strings.concatStrings ([  "\nnitch" ] ++ (if cfg.profiling then ["zprof"] else [""]));
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
                /*plugins = [
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
                ];*/
	              oh-my-zsh = mkIf cfg.ohmyzsh.enable {
	                enable = true;
                        theme = cfg.ohmyzsh.theme;
            	        plugins = cfg.ohmyzsh.plugins;
	              };
            };
        };
      };
}
