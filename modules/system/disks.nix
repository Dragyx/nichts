{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.system.disks;
  inherit (config.modules.system) username;
  inherit (config.users.users.${username}) uid;
  inherit (lib)
    mkIf
    mod
    types
    mkOption
    findSingle
    mkEnableOption
    optional
    ;
in
{
  options.modules.system.disks = {
    auto-partition.enable = mkEnableOption "disko";
    main-disk = mkOption {
      type = types.nullOr types.str;
      description = "The disk the system should be installed on";
      example = "/dev/nvme0n1";
      default = null;
    };
    esp-size = mkOption {
      type = types.strMatching "^[0-9]+[KMGTP]$";
      description = "Size the ESP (efi system partition should have)";
      default = "1G"; # I prefer 1GB since I have run out of space with NixOS before
      example = "512M";
    };
    swap-size = mkOption {
      # taken from https://github.com/nix-community/disko/blob/master/lib/types/btrfs.nix
      # but without the '?' after the expression since I require a nonempty string
      type = types.nullOr (types.strMatching "^[0-9]+[KMGTP]$");
      description = "Size the swapfile should have (possible units: K, M, G, T, P or none)";
      default = "32G";
      example = "1024M";
    };
    storage-disks = mkOption {
      type = types.attrsOf types.str;
      description = "Declare additional storage disks (The whole disk will be a btrfs volume)";
      default = { };
      example = {
        "extra" = "/dev/sda";
      };
    };
    lazy-load = mkOption {
      type = types.bool;
      description = "Whether to lazy-load the storage disks";
      default = true;
      example = false;
    };
    name-suffix = mkOption {
      type = types.str;
      description = ''
        Will rename partitions and cryptvolumes.
                MUST BE USED WHEN USING THIS CONFIGURATION AS INSTALLER FOR OTHER DEVICES.
                Otherwise disko can mess up existing partitions since they are called the same
      '';
      default = "";
      example = "INST";
    };
    boot-loader = mkOption {
      type = types.enum [
        "grub"
        "limine"
      ];
      description = "The boot loader to use. (currently: grub or limine)";
      default = "grub";
      example = "limine";
    };
  };

  config = mkIf cfg.auto-partition.enable {
    assertions = [
      {
        assertion = !((uid == null) && (cfg.storage-disks == { }));
        message = "To mount storage disks, the uid (users.users.<name>.uid) must be set!";
      }
    ];

    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };
    boot = {
      initrd.supportedFilesystems = [ "btrfs" ];
      supportedFilesystems = [ "btrfs" ];
      loader = {
        efi.efiSysMountPoint = "/boot";
        efi.canTouchEfiVariables = true;
        grub = {
          enable = cfg.boot-loader == "grub";
          device = "nodev";
          efiSupport = true;
          enableCryptodisk = true;
          extraEntries = ''
            menuentry "Reboot" {
              reboot
            }
            menuentry "Poweroff" {
              halt
            }
          '';
        };
        limine =

          let
            monitor =
              findSingle (monitor: monitor.displays-bootloader) null
                (throw "Multiple monitors have displays-bootloader set to true.")
                config.modules.system.monitors;
          in
          {
            enable = cfg.boot-loader == "limine";
            efiSupport = true;
            style =

              # figure out which display shows limine (by the manual marking on that monitor)
              {
                # disable the default NixOS background png
                wallpapers = [ ];
                interface = mkIf (monitor != null) {
                  resolution =
                    let
                      inherit (monitor.resolution) x y;
                      w = x |> toString;
                      h = y |> toString;
                    in
                    if mod monitor.transform 2 == 0 then "${w}x${h}" else "${h}x${w}";
                };
              };
            extraConfig = mkIf (monitor != null) ''
              interface_rotation: ${mod (360 - monitor.transform * 90) 360 |> toString}
            '';
          };
      };
    };

    # reference: https://haseebmajid.dev/posts/2024-07-30-how-i-setup-btrfs-and-luks-on-nixos-using-disko/
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = cfg.main-disk;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                label = "boot" + cfg.name-suffix;
                size = cfg.esp-size;
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "defaults" ];
                };
              };
              root = {
                size = "100%";
                label = "luks" + cfg.name-suffix;
                content = {
                  type = "luks";
                  name = "cryptroot" + cfg.name-suffix;
                  content = {
                    type = "btrfs";
                    extraArgs = [
                      "-L"
                      "nixos${cfg.name-suffix}"
                      "-f"
                    ];
                    subvolumes =
                      let
                        mkMountOptions = subvol: [
                          "subvol=${subvol}"
                          "compress=zstd"
                          "noatime"
                        ];
                      in
                      {
                        "/root" = {
                          mountpoint = "/";
                          mountOptions = mkMountOptions "root";
                        };
                        "/home" = {
                          mountpoint = "/home";
                          mountOptions = mkMountOptions "home";
                        };
                        "/nix" = {
                          mountpoint = "/nix";
                          mountOptions = mkMountOptions "nix";
                        };
                        "/log" = {
                          mountpoint = "/var/log";
                          mountOptions = mkMountOptions "log";
                        };
                        "/swap" = mkIf (cfg.swap-size != null) {
                          mountpoint = "/swap";
                          swap.swapfile.size = cfg.swap-size;
                        };
                      };
                  };
                };
              };
            };
          };
        };
      }
      // lib.mapAttrs (name: device: {
        type = "disk";
        device = device;
        content = {
          type = "gpt";
          partitions = {
            "${name}${cfg.name-suffix}" = {
              size = "100%";
              label = "luks-${name}${cfg.name-suffix}";
              content = {
                type = "luks";
                name = "crypt-${name}${cfg.name-suffix}";
                settings = {
                  keyFile = "/keyfile";
                };
                # We don't wan't to set up these disks in stage 1
                #
                # Instead, they should be opened during the normal
                # boot process.
                initrdUnlock = false;
                # FIXME: Note that this has not been yet tested as I am unwilling
                # to reinstall my whole system to test this option
                #
                # It is also pretty unclean, as this should really be done
                # by disko itself during the install process
                preCreateHook = ''
                  if [ ! -f /keyfile ]; then
                    dd if=/dev/urandom of=/keyfile bs=1024 count=8
                    chmod 0400 /keyfile
                  fi
                '';
                postMountHook = ''
                  if [ ! -f /mnt/keyfile ]; then
                    cp /keyfile /mnt/keyfile
                    chmod 0400 /mnt/keyfile
                  fi
                '';
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-L"
                    "${name}${cfg.name-suffix}"
                    "-f"
                  ];
                  subvolumes = {
                    "/${name}" = {
                      mountpoint = "/disk-${name}";
                      # make accessible for user
                      mountOptions = [
                        "subvol=${name}"
                        "compress=zstd"
                        "noatime"
                      ]
                      ++ optional cfg.lazy-load "nofail";
                    };
                  };
                };
              };
            };
          };
        };
      }) cfg.storage-disks;
    };
    fileSystems."/var/log".neededForBoot = true;

    # use the keyfile
    environment.etc.crypttab.text = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: _:
        let
          options = [
            "luks"
          ]
          # Don't wait for the disks if lazy-loading is enabled.
          ++ optional cfg.lazy-load "nofail";
          options_formatted = lib.concatStringsSep "," options;
        in
        "crypt-${name}${cfg.name-suffix} /dev/disk/by-partlabel/luks-${name}${cfg.name-suffix} /keyfile ${options_formatted}"
      ) cfg.storage-disks
    );
  };
}
