{ pkgs, lib, ... }:
{
  networking.hostId = "aefab460";
  systemd.services.zfs-mount.enable = true;
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [ networkmanager ]; # cli tool for managing connections

  services.gnome.gnome-keyring.enable = true;

  virtualisation.docker.enable = true;
  users.users.dragyx.extraGroups = [ "docker" ];
  security.polkit.enable = true;

  modules = {
    system = rec {
      network.hostname = "schnee";
      username = "dragyx";
      gitPath = "/home/${username}/repos/nichts";
      nvidia.enable = true;
      monitors = [
        {
          name = "Main";
          device = "DP-2";
          resolution = {
            x = 2560;
            y = 1440;
          };
          scale = 1.0;
          refresh_rate = 143.998001;
          position = {
            x = 0;
            y = 0;
          };
        }
        {
          name = "Right";
          device = "HDMI-A-3";
          resolution = {
            x = 2560;
            y = 1440;
          };
          scale = 1.0;
          refresh_rate = 74.9999001;
          position = {
            x = 2560;
            y = 200;
          };
          transform = 3;
        }
        {
          name = "Left";
          device = "HDMI-A-2";
          resolution = {
            x = 2560;
            y = 1440;
          };
          scale = 1.0;
          refresh_rate = 74.9999001;
          position = {
            x = -1440;
            y = 200;
          };
          transform = 1;
          displays-bootloader = true;
        }
      ];
      boot-loader = "limine";
      disks = {
        auto-partition.enable = true;
        swap-size = "64G";
        main-disk = "/dev/disk/by-id/nvme-Samsung_SSD_960_PRO_512GB_S3EWNX0K401532W";
        storage-disks = {
          "medium" = "/dev/disk/by-id/wwn-0x50026b7783226e2f";
          "large" = "/dev/disk/by-id/wwn-0x5000c500bda8dba1";
        };
      };
    };
    other.home-manager = {
      enable = true;
      enableDirenv = true;
    };
    programs = {
      steam.enable = true;
      steam.gamescope = true;
      firefox.enable = true;
      btop.enable = true;
      mpv.enable = true;
      zed.enable = true;
      obs.enable = true;
      zathura.enable = true;
      git = {
        enable = true;
        defaultBranch = "main";
      };
      starship.enable = true;
    };
    services = {
      pipewire.enable = true;
    };
    theming = {
      enable = true;
      scheme = "tokyo-night-dark";
      base = 24;
    };
    cosmic = {
      enable = true;
      greeter.enable = true;
    };
  };
  specialisation = {
    light.configuration.modules.theming.scheme = lib.mkForce "tokyo-night-light";
  };

  system.stateVersion = "21.11"; # Did you read the comment?

}
