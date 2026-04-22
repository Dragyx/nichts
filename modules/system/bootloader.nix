{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    findSingle
    types
    mkOption
    mkIf
    mod
    ;
  cfg = config.modules.system;
in
{

  options.modules.system.boot-loader = mkOption {
    type = types.enum [
      "grub"
      "limine"
    ];
    description = "The boot loader to use. (currently: grub or limine)";
    default = "grub";
    example = "limine";
  };
  config.boot = {
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

}
