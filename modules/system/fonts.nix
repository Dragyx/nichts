{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.system.fonts;
  inherit (lib) mkIf mkEnableOption;
in {
  options.modules.system.fonts.enable = mkEnableOption "fonts";
  config.fonts.packages = mkIf cfg.enable (with pkgs; [
    material-design-icons
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    iosevka
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
  ]);
}
