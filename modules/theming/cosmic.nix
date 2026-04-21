{
  scheme,
  mkIf,
  enable,
  pkgs,
  username,
  lib,
  ...
}:
let
  polarity = if scheme.variant == "light" then "Light" else "Dark";
  mkColor =
    hexval:
    let
      to_float = n: (lib.trivial.fromHexString n) / 255.0;
      r = hexval |> lib.substring 0 2 |> to_float |> toString;
      g = hexval |> lib.substring 2 2 |> to_float |> toString;
      b = hexval |> lib.substring 4 2 |> to_float |> toString;
    in
    ''
      (
        red: ${r},
        green: ${g},
        blue: ${b},
        alpha: 1.0,
      )
    '';
  indent =
    content: content |> lib.splitString "\n" |> lib.concatMapStringsSep "\n" (line: "  " + line);
  wrap_enum = name: content: ''
    ${name}(
    ${indent content}
    )
  '';
  make_tuple = vals: "(${lib.concatStringsSep ", " vals})";
  attrs_to_class = attrs: map_inner: ''
    (
    ${lib.concatMapAttrsStringSep "" (name: value: ''
      ${name}: ${map_inner name value},
    '') attrs}
    )
  '';
  # references:
  # - https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/catppuccin-mocha.yaml
  # - https://github.com/catppuccin/cosmic-desktop/blob/main/templates/cosmic-settings.tera
  themeText = attrs_to_class {
    palette = wrap_enum polarity (
      attrs_to_class (with scheme; {
        name = scheme-name;
        inherit
          blue
          red
          green
          yellow
          ;
        bright_orange = base09;
        bright_green = bright-green;
        bright_red = bright-red;

        gray_1 = base01;
        gray_2 = base00;
        gray_3 = base02;

        neutral_0 = base11;
        neutral_1 = base01;
        neutral_2 = base00;
        neutral_3 = base02;
        neutral_4 = base03;
        neutral_5 = base04;
        neutral_6 = base05;
        neutral_7 = base06;
        neutral_8 = base07;
        neutral_9 = base08;
        neutral_10 = base09;

        ext_warm_grey = base07;
        ext_orange = base09;
        ext_yellow = base0A;
        ext_blue = base0D;
        ext_purple = base07;
        ext_pink = base17;
        ext_indigo = base0E;

        accent_blue = base0D;
        accent_red = base08;
        accent_green = base0B;
        accent_warm_grey = base07;
        accent_orange = base09;
        accent_yellow = base0A;
        accent_purple = base07;
        accent_pink = base17;
        accent_indigo = base0E;
      }) (key: val: if key == "name" then "\"${val}\"" else mkColor val |> indent)
    );
    spacing = attrs_to_class {
      space_none = 0;
      space_xxxs = 4;
      space_xxs = 8;
      space_xs = 12;
      space_s = 16;
      space_m = 24;
      space_l = 32;
      space_xl = 48;
      space_xxl = 64;
      space_xxxl = 128;
    } (_: val: toString val |> indent);
    corner_radii = attrs_to_class {
      radius_0 = make_tuple [
        "0.0"
        "0.0"
        "0.0"
        "0.0"
      ];
      radius_xs = make_tuple [
        "4.0"
        "4.0"
        "4.0"
        "4.0"
      ];
      radius_s = make_tuple [
        "8.0"
        "8.0"
        "8.0"
        "8.0"
      ];
      radius_m = make_tuple [
        "16.0"
        "16.0"
        "16.0"
        "16.0"
      ];
      radius_l = make_tuple [
        "32.0"
        "32.0"
        "32.0"
        "32.0"
      ];
      radius_xl = make_tuple [
        "160.0"
        "160.0"
        "160.0"
        "160.0"
      ];
    } (_: val: val |> indent);
    text_tint = wrap_enum "Some" (mkColor scheme.base05);
    accent = wrap_enum "Some" (mkColor scheme.base06);
    success = wrap_enum "Some" (mkColor scheme.base0B);
    warning = wrap_enum "Some" (mkColor scheme.base0A);
    destructive = wrap_enum "Some" (mkColor scheme.base08);
    window_hint = wrap_enum "Some" (mkColor scheme.base06);
    neutral_tint = wrap_enum "Some" (mkColor scheme.base06);
    primary_container_bg = wrap_enum "Some" (mkColor scheme.base02);
    secondary_container_bg = wrap_enum "Some" (mkColor scheme.base03);
    is_frosted = "false";
    gaps = make_tuple [
      "0"
      "8"
    ];
    active_hint = "3";
  } (_: val: val |> indent);
  cosmicTheme = pkgs.writeText "cosmic-theme-${scheme.slug}.ron" themeText;
in
{
  home-manager.users.${username} = mkIf enable (
    { lib, ... }:
    {
      home.activation.applyCosmicTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        echo "Importing COSMIC theme ${scheme.scheme-name} (${scheme.variant}) from ${cosmicTheme}"
        ${lib.getExe' pkgs.cosmic-settings "cosmic-settings"} appearance import "${cosmicTheme}"
      '';
    }
  );

}
