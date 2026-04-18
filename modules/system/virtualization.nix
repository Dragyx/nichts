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
    virtualisation = {
      spiceUSBRedirection.enable = true;

      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          vhostUserPackages = [ pkgs.virtiofsd ];
        };
      };
    };

    home-manager.users.${username} = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    };

  };
}
