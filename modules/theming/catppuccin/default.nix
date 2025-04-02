{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  username = config.modules.system.username;
  cfg = config.modules.theming.themes.catppuccin;
  inherit (lib) mkIf mkOption types;
in {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    # TODO: maybe write a nice function for less boilerplate
    (import ./waybar.nix {
      enabled = cfg.enable;
      inherit config lib;
    })
    (import ./cursor.nix {
      enabled = cfg.enable;
      inherit config lib pkgs;
    })
    /*
    (import ./firefox.nix {
      enabled = cfg.enable;
      inherit config lib pkgs;
    })
    */

    ./hyprland.nix
    ./zathura.nix
  ];

  config = mkIf cfg.enable {
    catppuccin = {
      enable = true;
      flavor = cfg.flavor;
    };
    home-manager.users.${username} = {
      catppuccin = {
        enable = true;
        flavor = cfg.flavor;
      };
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];
    };
  };
  options = {
    modules.theming.themes.catppuccin = {
      flavor = mkOption {
        type =
          types.enum ["latte" "frappe" "macchiate" "mocha"];
        default = "mocha";
        example = "latte";
        description = "Select which catppuccin flavor to use";
      }; #TODO: add accents
      accent = mkOption {
        type = types.enum [
          "rosewater"
          "flamingo"
          "pink"
          "mauve"
          "red"
          "maroon"
          "peach"
          "yellow"
          "green"
          "teal"
          "sky"
          "sapphire"
          "blue"
          "lavender"
        ];
        default = "mauve";
        example = "maroon";
        description = "Set an accent color where possible";
      };
    };
  };
}
