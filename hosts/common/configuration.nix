{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  username = config.modules.system.username;
in {
  imports = [
    ../../options/common/pin-registry.nix
    ../../options/common/preserve-system.nix
    ../../options/desktop/fonts.nix
  ];

  home-manager.backupFileExtension = "bak";
  networking.dhcpcd.wait = "background";
  services.locate = {
    enable = true;
    interval = "hourly";
    package = pkgs.plocate;
    localuser = null;
  };

  #TODO: MOVE this somewhere else
  users.users.${username}.uid = 1000;

  modules = {
    programs = {
      foot.enable = lib.mkDefault true;
      foot.server = lib.mkDefault true;
      nh.enable = lib.mkDefault true;
      fish.enable = lib.mkDefault true;
      atuin.enable = lib.mkDefault true;
      zellij.enable = lib.mkDefault true;
      editors.helix.enable = lib.mkDefault true;

      firefox.extensions = {
        "bitwarden-password-manager" = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
        "darkreader" = "addon@darkreader.org";
        "tree-style-tab" = "treestyletab@piro.sakura.ne.jp";
        "vvz-coursereview" = "{64a9abc5-b0dd-4855-831c-7b73290c0613}";
        "privacy-badger17" = "jid1-MnnxcxisBPnSXQ@jetpack";
        "terms-of-service-didnt-read" = "jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack";
        "multi-account-containers" = "@testpilot-containers";
      };
    };
    theming.theme = "catppuccin";
  };

  time.timeZone = "Europe/Zurich";
}
