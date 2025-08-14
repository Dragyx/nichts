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
      inherit (cfg) flavor accent;
    };
    qt.style.catpupuccin = {
      enable = true;
      apply = true;
      inherit (cfg) flavor accent;
    };
    # qt.platformTheme.name = "catppuccin";
    home-manager.users.${username} = {
      # FIXME: remove this temporary hack
      # (used to get home-manager to build)
      catppuccin.mako.enable = false;
      catppuccin = {
        enable = true;
        flavor = cfg.flavor;
      };
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];
      gtk = {
        enable = true;
      };
      qt = {
        enable = true;
        style.name = "kvantum";
        platformTheme.name = "kvantum";
      };
      home.sessionVariables = {
        GTK_THEME = "catppuccin";
        GTK_USE_PORTAL = "1";
      };
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
      };
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
