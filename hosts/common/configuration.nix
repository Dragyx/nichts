{
  config,
  pkgs,
  lib,
  ...
}:
let
  username = config.modules.system.username;
  inherit (lib) mkDefault;
in
{
  home-manager.backupFileExtension = "bak";
  networking.dhcpcd.wait = "background";
  services.locate = {
    enable = true;
    interval = "hourly";
    package = pkgs.plocate;
  };
  security.sudo.package = pkgs.sudo.override { withInsults = true; };

  nixpkgs.config.allowUnfree = true;

  #TODO: MOVE this somewhere else
  users.users.${username} = {
    initialPassword = username;
    uid = 1000;
  };
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ zlib ];
  };

  modules = {
    system = {
      bluetooth.enable = true;
      network.enable = true;
      fonts.enable = true;
    };
    programs = {
      foot.enable = mkDefault true;
      foot.server = mkDefault true;
      nh.enable = mkDefault true;
      radare2.enable = mkDefault true;
      fish.enable = mkDefault true;
      carapace.enable = mkDefault true;
      atuin.enable = mkDefault true;
      zed.enable = mkDefault true;
      zellij.enable = mkDefault true;
      jujutsu.enable = mkDefault true;
      editors.helix = {
        enable = mkDefault true;
        default = mkDefault true;
      };
      git.pullRebase = mkDefault true; # avoid merge hell

      firefox.extensions = {
        "bitwarden-password-manager" = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
        "darkreader" = "addon@darkreader.org";
        "vvz-coursereview" = "{64a9abc5-b0dd-4855-831c-7b73290c0613}";
        "privacy-badger17" = "jid1-MnnxcxisBPnSXQ@jetpack";
        "terms-of-service-didnt-read" = "jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack";
        "multi-account-containers" = "@testpilot-containers";
        "ublock-origin" = "uBlock0@raymondhill.net";
      };
    };
    theming.theme = "catppuccin";
  };

  time.timeZone = "Europe/Zurich";
}
