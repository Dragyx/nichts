{
  mkIf,
  enable,
  username,
  scheme,
  lib,
  ...
}:
let
  mkColor =
    hexval:
    {
      r = (hexval |> builtins.substring 0 2);
      g = (hexval |> builtins.substring 2 2);
      b = (hexval |> builtins.substring 4 2);
    }
    |> lib.mapAttrs (_: lib.trivial.fromHexString);
in
{
  # use the firefox module already implemented by this flake
  modules.programs.firefox.extensions = {
    "firefox-color" = "FirefoxColor@mozilla.com";
  };
  # inspired by https://github.com/nix-community/stylix/blob/master/modules/firefox/each-config.nix
  home-manager.users.${username}.programs.firefox = mkIf enable {
    profiles.default = {
      extensions = {
        # /*
        settings."FirefoxColor@mozilla.com".settings = {
          firstRunDone = true;
          theme = with scheme; {
            title = "Base165 ${scheme-name}";
            colors = lib.mapAttrs (_: mkColor) {
              toolbar = base00;
              toolbar_text = base05;
              frame = base01;
              tab_background_text = base05;
              toolbar_field = base02;
              toolbar_field_text = base05;
              tab_line = base0D;
              popup = base00;
              popup_text = base05;
              button_background_active = base04;
              frame_inactive = base00;
              icons_attention = base0D;
              icons = base05;
              ntp_background = base00;
              ntp_text = base05;
              popup_border = base0D;
              popup_highlight_text = base05;
              popup_highlight = base04;
              sidebar_border = base0D;
              sidebar_highlight_text = base05;
              sidebar_highlight = base0D;
              sidebar_text = base05;
              sidebar = base00;
              tab_background_separator = base0D;
              tab_loading = base05;
              tab_selected = base00;
              tab_text = base05;
              toolbar_bottom_separator = base00;
              toolbar_field_border_focus = base0D;
              toolbar_field_border = base00;
              toolbar_field_focus = base00;
              toolbar_field_highlight_text = base00;
              toolbar_field_highlight = base0D;
              toolbar_field_separator = base0D;
              toolbar_vertical_separator = base0D;
            };
          };
        };
      };
    };
  };
}
