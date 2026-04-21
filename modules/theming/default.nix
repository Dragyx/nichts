{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    filesystem
    attrNames
    mkEnableOption
    mkOption
    types
    flip
    filterAttrs
    ;
  username = config.modules.system.username;
  cfg = config.modules.theming;
in
{
  options.modules.theming = {
    enable = mkEnableOption "theming";
    scheme = mkOption {
      type = types.str;
      default = "catppuccin-mocha";
      description = "The theming scheme to use. Sets config.scheme internally by selecting the correct yaml from tinted-theming (base16.nix).";
    };
    base = mkOption {
      type = types.enum [
        16
        24
      ];
      default = 16;
      example = 24;
      description = "Whether the theme is supplied in base16 color format or tinted-theming (base24) color format.";
    };
  };
  # import all other files in the directory
  imports =
    filesystem.readDir ./.
    |> filterAttrs (n: v: v == "regular" && n != "default.nix")
    |> attrNames
    |> map (f: ./. + "/${f}")
    |> map (
      flip import {
        inherit
          username
          config
          pkgs
          lib
          ;
        inherit (lib) mkIf;
        inherit (cfg) enable;
        name = cfg.scheme;
        scheme = config.lib.base16.mkSchemeAttrs config.scheme;
      }
    );
  # set the internal base16 theme
  config.scheme = "${inputs.tt-schemes}/base${toString cfg.base}/${cfg.scheme}.yaml";
}
