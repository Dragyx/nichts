{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types mapAttrs';
  username = config.modules.system.username;
  cfg = config.modules.programs.firefox;
  mkFirefoxExtension = name: id:
    lib.nameValuePair id {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
      installation_mode = "force_installed";
    };
in {
  options.modules.programs.firefox = {
    enable = mkEnableOption "firefox";
    extensions = mkOption {
      description = "firefox extensions (formatted as { name = id; } attrset)";
      type = types.attrs;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.firefox = {
        enable = true;
        profiles = {
          default = {
            id = 0;
            isDefault = true;
            search.default = "ddg";
            search.force = true;
            extensions.force = true;
            settings = {
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "media.ffmpeg.vaapi.enabled" = true; # enable hardware accelerated video playback (vaapi)
              "media.peerconnection.enabled" = false;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            };
            containersForce = true;
            containers = {
              nix = {
                color = "blue";
                icon = "circle";
                id = 0;
              };
              dangerous = {
                color = "red";
                icon = "fruit";
                id = 1;
              };
              shopping = {
                color = "yellow";
                icon = "cart";
                id = 2;
              };
              video = {
                color = "pink";
                icon = "vacation";
                id = 3;
              };
              studying = {
                color = "green";
                icon = "fence";
                id = 4;
              };
            };
          };
        };

        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          DisablePocket = true;
          DisableFirefoxAccounts = true;
          DisableAccounts = true;
          DisableFirefoxScreenshots = true;
          OverrideFirstRunPage = "";
          OverridePostUpdatePage = "";
          DontCheckDefaultBrowser = true;
          DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
          DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
          SearchBar = "unified"; # alternative: "separate"
          FirefoxSuggest = {
            WebSuggestions = true;
            ImproveSuggest = true;
            Locked = true;
          };
          SearchSuggestEnabled = true;
          theme = {
            colors = {
              background-darker = "181825";
              background = "1e1e2e";
              foreground = "cdd6f4";
            };
          };

          OfferToSaveLogins = false;
          font = "Lexend";
          ExtensionSettings = mapAttrs' mkFirefoxExtension cfg.extensions;
        };
      };
    };
  };
}
