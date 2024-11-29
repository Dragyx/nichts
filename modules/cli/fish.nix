{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.fish;
  username = config.modules.system.username;
  gitPath = config.modules.system.gitPath;
  inherit (lib) mkIf mkEnableOption mkOption types mkForce mkMerge getExe;
in {
  options.modules.programs.fish = {
    enable = mkEnableOption "fish";
    extraAliases = mkOption {
      type = types.attrs;
      description = "extra shell aliases";
      default = {};
    };
  };

  config = mkIf cfg.enable {
    programs.fish.enable = true;

    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    programs.command-not-found.enable = mkForce false;
    users.users.${username}.shell = pkgs.fish;

    environment = {
      shells = [pkgs.fish];
      pathsToLink = ["/share/fish"];
      systemPackages = with pkgs; [eza bat nh zellij lazygit];
    };

    home-manager.users.${username} = {
      programs.fish = {
        enable = true;
        interactiveShellInit = "set fish_greeting";
        plugins = [
          {
            name = "sponge";
            inherit (pkgs.fishPlugins.sponge) src;
          }
          {
            name = "done";
            inherit (pkgs.fishPlugins.done) src;
          }
          {
            name = "puffer";
            inherit (pkgs.fishPlugins.puffer) src;
          }
        ];
        shellAbbrs = mkMerge [
          {
            rebuild = "nh os switch";
            update = "nh os switch --update";
            cat = "bat --plain";
            cl = "clear";
            cp = "cp -ivr";
            mv = "mv -iv";
            ls = "eza --icons auto";
            la = "eza --icons auto -a";
            ll = "eza --icons auto -lha";
            lt = "eza --icons auto -T";
            zj = "zellij";
            lg = "lazygit";
            ns = "nix repl --expr 'import <nixpkgs>{}'";
            man = "man -P bat";
            gpl = "curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
            agpl = "curl https://www.gnu.org/licenses/agpl-3.0.txt -o LICENSE";
            flake = "cd \"${gitPath}\"";
          }
          cfg.extraAliases
        ];
      };
    };
  };
}
