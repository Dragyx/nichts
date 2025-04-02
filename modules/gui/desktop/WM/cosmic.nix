{
  config,
  lib,
  ...
}: let
  cfg = config.modules.WM.cosmic;
  inherit (lib) mkEnableOption mkIf;
in {
  options.modules.WM.cosmic.enable = mkEnableOption "cosmic";

  config = mkIf cfg.enable {
    # see https://github.com/lilyinstarlight/nixos-cosmic
    nix.settings = {
      substituters = ["https://cosmic.cachix.org/"];
      trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
    };
    # services.desktopManager.cosmic.enable = true;
  };
}
