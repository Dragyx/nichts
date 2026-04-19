{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.modules.system.wayland = mkOption {
    type = types.bool;
    description = "Does this system use wayland?";
    default = false;
  };
}
