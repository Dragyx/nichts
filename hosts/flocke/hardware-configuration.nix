{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  # see https://nixos.wiki/wiki/AMD_GPU
  services.xserver.videoDrivers = ["modesetting"];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2aaba0f2-e8dc-4583-a81e-2d35cc238e79";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9D34-36F8";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 2 * 32 * 1024; # twice the size of system ram for hibernation
    }
  ];

  boot.kernelParams = ["resume_offset=228702208"];
  boot.resumeDevice = "/dev/mapper/cryptroot"; # needed for hibernation to work
  # see https://discourse.nixos.org/t/hibernate-doesnt-work-anymore/24673/5
  security.protectKernelImage = false;
  # see https://discourse.nixos.org/t/btrfs-swap-not-enough-swap-space-for-hibernation/36805/4
  systemd.services.systemd-logind.environment = {
    SYSTEMD_BYPASS_HIBERNATION_MEMORY_CHECK = "1";
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
