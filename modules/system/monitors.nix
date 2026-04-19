{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.modules.system.monitors = mkOption {
    description = "
      List of monitors to use
    ";
    default = [ ];
    type =
      with types;
      listOf (submodule {
        options = {
          name = mkOption {
            type = str;
            description = "Give your monitor a cute name";
            default = "monitor0(I am lazy)";
          };
          device = mkOption {
            type = str;
            description = "The actual device name of the monitor";
          };
          resolution = mkOption {
            type = submodule {
              options = {
                x = mkOption {
                  type = int;
                  description = "monitor width";
                  default = "1920";
                };
                y = mkOption {
                  type = int;
                  description = "monitor height";
                  default = "1080";
                };
              };
            };
          };
          scale = mkOption {
            type = number;
            description = "monitor scale";
            default = 1.0;
          };
          refresh_rate = mkOption {
            type = float;
            description = "monitor refresh rate (in Hz)";
            default = 60;
          };
          position = mkOption {
            type = submodule {
              options = {
                x = mkOption {
                  type = int;
                  default = 0;
                };
                y = mkOption {
                  type = int;
                  default = 0;
                };
              };
            };

            description = "absolute monitor posititon";
            default = {
              x = 0;
              y = 0;
            };
          };
          transform = mkOption {
            type = ints.between 0 3;
            description = "Rotation of the monitor counterclockwise";
            default = 0;
          };
          displays-bootloader = mkOption {
            type = bool;
            description = "Used to set settings like the correct rotation for the bootloader";
            default = false;
            example = true;
          };
        };
      });
  };
}
