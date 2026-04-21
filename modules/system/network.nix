{
  config,
  lib,
  ...
}:
let
  username = config.modules.system.username;
  cfg = config.modules.system.network;
  inherit (lib)
    mkIf
    mkEnableOption
    types
    mkOption
    ;
in
{
  options.modules.system.network = {
    enable = mkEnableOption "networking";
    hostname = mkOption {
      description = "hostname for this system";
      type = types.str;
    };
  };
  config = mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };
      hostName = cfg.hostname;
    };
    services.resolved = {
      enable = true;
      settings.Resolve.FallbackDNS = [
        "9.9.9.9"
        "2620::fe::fe"
      ];
    };
    users.users.${username}.extraGroups = [ "networkmanager" ];
  };
}
