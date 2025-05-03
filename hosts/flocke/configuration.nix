{
  pkgs,
  config,
  ...
}: let
  username = config.modules.system.username;
in {
  imports = [
    ../common/default.nix
    ./packages.nix
  ];

  # framework specific for BIOS updates
  services.fwupd.enable = true;
  virtualisation.docker.enable = true;
  users.users.${username}.extraGroups = ["docker"];

  # virtualisation.docker.rootless = {
  #   enable = true;
  #   setSocketVariable = true;
  # };

  services.logrotate.checkConfig = false;

  networking.hostId = "adf23c31";
  networking.interfaces.wlp1s0.useDHCP = true;
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [networkmanager]; # cli tool for managing connections

  boot = {
    kernelParams = [];
    initrd.supportedFilesystems = ["ext4"];
    supportedFilesystems = ["ext4"];
    loader = {
      efi.efiSysMountPoint = "/boot";
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
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
    };
    initrd.luks.devices = {
      cryptroot = {
        device = "/dev/disk/by-uuid/ec5ff3a1-9b39-4ba5-aa0f-19e898b4f6e8";
        preLVM = true;
      };
    };
  };

  # be nice to your ssds
  services.fstrim.enable = true;

  security.polkit.enable = true;

  modules = {
    login = {
      greetd.enable = true;
      session = "Hyprland";
    };
    system = rec {
      network.hostname = "flocke";
      username = "dragyx";
      gitPath = "/home/${username}/repos/nichts";
      bluetooth.enable = true;
      monitors = [
        {
          name = "LaptopMain";
          device = "eDP-1";
          resolution = {
            x = 2256;
            y = 1504;
          };
          scale = 1.333333; # 1.175;
          refresh_rate = 60.0;
          position = {
            x = 0;
            y = 0;
          };
        }
        rec {
          name = "CodingWeekend";
          device = "DP-9";
          resolution = {
            x = 2560;
            y = 1440;
          };
          refresh_rate = 60.0;
          scale = 1;
          position = {
            x = -152;
            y = -resolution.y;
          };
        }
        rec {
          name = "CodingWeekend2";
          device = "DP-10";
          resolution = {
            x = 2560;
            y = 1440;
          };
          refresh_rate = 60.0;
          scale = 1;
          position = {
            x = -152;
            y = -resolution.y;
          };
        }
      ];
      wayland = true;
    };
    other.home-manager = {
      enable = true;
      enableDirenv = true;
    };
    programs = {
      minecraft.enable = false;
      minecraft.wayland = true;
      vesktop.enable = false;
      btop.enable = true;
      mpv.enable = true;
      firefox.enable = true;
      obs.enable = true;
      rofi.enable = true;
      zathura.enable = true;
      steam = {
        enable = true;
        gamescope = true;
      };
      git = {
        enable = true;
        defaultBranch = "main";
      };
      starship.enable = true;
    };
    services.pipewire.enable = true;

    WM = {
      waybar.enable = true;
      hyprland = {
        enable = true;
        gnome-keyring.enable = true;
      };
      quickshell = {
        enable = true;
        bar.enable = true;
      };
      cosmic.enable = false;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
