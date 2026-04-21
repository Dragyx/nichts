{
  mkIf,
  enable,
  scheme,
  ...
}:
{
  # inspired by the catppuccin nix theme
  boot.loader.limine.extraConfig =
    with scheme;
    ''
      term_palette: ${base00-hex};${base08-hex};${base14-hex};${base0A-hex};${base0D-hex};${base17-hex};${base0C-hex};${base05-hex}
      term_palette_bright: ${base04-hex};${base08-hex};${base14-hex};${base0A-hex};${base0D-hex};${base17-hex};${base0C-hex};${base05-hex}
      term_background: ${base00-hex}
      term_foreground: ${base05-hex}
      term_background_bright: ${base04-hex}
      term_foreground_bright: ${base05-hex}
    ''
    |> mkIf enable;
}
