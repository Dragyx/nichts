{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.nvidia;
  inherit (lib) mkIf mkEnableOption mkMerge;
  nvidia-pkg = config.boot.kernelPackages.nvidiaPackages.stable;
in {
  options.modules.system.nvidia.enable = mkEnableOption "nvidia";
  config = mkIf cfg.enable {
    # taken (mostly) from https://github.com/bloxx12/nichts/blob/main/options/common/gpu/nvidia.nix
    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        nvidia-vaapi-driver
        libvdpau-va-gl
        libva-vdpau-driver
        egl-wayland
      ];
    };

    environment.systemPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      libva
      libva-utils
    ];
    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      package = nvidia-pkg;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      nvidiaSettings = false;
    };

    environment.sessionVariables = mkMerge [
      {
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __GL_GSYNC_ALLOWED = "0";
        __EGL_VENDOR_LIBRARY_FILENAMES = "${nvidia-pkg}/share/glvnd/egl_vendor.d/10_nvidia.json";
      }
      (mkIf config.modules.system.wayland {
        XDG_SESSION_TYPE = "wayland";
        GDK_BACKEND = "wayland";
        QT_QPA_PLATFORM = "wayland";
        NIXOS_XDG_OPEN_USE_PORTAL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        GTK_USE_PORTAL = "1";
      })
      (mkIf config.modules.WM.hyprland.enable {
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
      })
    ];
  };
}
