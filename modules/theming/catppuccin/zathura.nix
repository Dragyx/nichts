{
  config,
  lib,
  ...
}: let
  username = config.modules.system.username;
  cfg = config.modules.theming.themes.catppuccin;
  inherit (lib) mkIf;
in {
  # make sure the option is really only set if catpuccin theming is enabled;
  # otherwise the theming would have a dependency on the catpuccin input even
  # if disabled
  config = mkIf cfg.enable {
    # disable catppuccin for zathura, as books, documents should not be themed
    home-manager.users.${username}.catppuccin.zathura.enable = false;
  };
}
