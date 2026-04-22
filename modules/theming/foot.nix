{
  scheme,
  enable,
  mkIf,
  username,
  ...
}:
let
  polarity = if scheme.variant == "light" then "light" else "dark";
  settings = mkIf enable {
    main.initial-color-theme = polarity;
    "colors-${polarity}" = with scheme; {
      foreground = base05;
      background = base00;
      regular0 = base00;
      regular1 = base08;
      regular2 = base0B;
      regular3 = base0A;
      regular4 = base0D;
      regular5 = base0E;
      regular6 = base0C;
      regular7 = base05;
      bright0 = base03;
      bright1 = base08;
      bright2 = base0B;
      bright3 = base0A;
      bright4 = base0D;
      bright5 = base0E;
      bright6 = base0C;
      bright7 = base07;
      "16" = base09;
      "17" = base0F;
      "18" = base01;
      "19" = base02;
      "20" = base04;
      "21" = base06;
    };
  };
in
{
  # inspired by https://github.com/nix-community/stylix/blob/master/modules/foot/hm.nix
  programs.foot.settings = settings;
  home-manager.users.${username}.programs.foot.settings = settings;
}
