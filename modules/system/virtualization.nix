{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.modules.system) username;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.system.virtualization;
in
{
  options.modules.system.virtualization = {
    enable = mkEnableOption "Virt-manager and other virtualization tools";
  };

  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ username ];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    home-manager.users.${username} = {

    };

  };
}
