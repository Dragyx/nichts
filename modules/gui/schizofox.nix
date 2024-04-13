{ config, inputs, lib, ... }:
with lib; let
    cfg = config.modules.programs.schizofox;
    username = config.modules.other.system.username;
in {
    options.modules.programs.schizofox = {
        enable = mkEnableOption "schizofox";
    };

    config = mkIf cfg.enable {
        home-manager.users.${username} = {
            imports = [ inputs.schizofox.homeManagerModule ];

            programs.schizofox = {
                enable = true;
                theme = {
                    colors.background-darker = "181825";
                    colors.background = "1e1e2e";
                    colors.foreground = "cdd6f4";
                    font = "Lexend";
                   extraUserChrome = ''
                        body {
                            color: red !important;
                        }
                    '';
                };
                extensions = {
                    simplefox.enable = false;
                    darkreader.enable = true;
                };
                search = {
                    defaultSearchEngine = "Brave";
                    removeEngines = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
                    addEngines = [
                        {
                            Name = "NixOS Packages";
                            Description = "NixOS Unstable package search";
                            Alias = "!np";
                            Method = "GET";
                            URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
                        }
                        {
                            Name = "NixOS Options";
                            Description = "NixOS Unstable option search";
                            Alias = "!no";
                            Method = "GET";
                            URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
                        }
                        {
                            Name = "NixOS Wiki";
                            Description = "NixOS Wiki search";
                            Alias = "!nw";
                            Method = "GET";
                            URLTemplate = "https://nixos.wiki/index.php?search={searchTerms}";
                        }
                        {
                            Name = "Home Manager Options";
                            Description = "Home Manager option search";
                            Alias = "!hm";
                            Method = "GET";
                            URLTemplate = "https://mipmip.github.io/home-manager-option-search?query={searchTerms}";
                        }
                        {
                            Name = "Arch Wiki";
                            Description = "Arch Wiki search";
                            Alias = "!aw";
                            Method = "GET";
                            URLTemplate = "https://wiki.archlinux.org/index.php?search={searchTerms}";
                        }
                        {
                            Name = "Gentoo Wiki";
                            Description = "Gentoo Wiki search";
                            Alias = "!gw";
                            Method = "GET";
                            URLTemplate = "https://wiki.gentoo.org/index.php?search={searchTerms}";
                        }
                        {
                            Name = "Debian Wiki";
                            Description = "Debian Wiki search";
                            Alias = "!dw";
                            Method = "GET";
                            URLTemplate = "https://wiki.debian.org/FrontPage?action=fullsearch&value={searchTerms}";
                        }
                    ];
                };

                security = {
                    sanitizeOnShutdown = true;
                    sandbox = true;
                    userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
                };

                misc = {
                    drmFix = false;
                    disableWebgl = true;
                };
            };
        };
    };
}
