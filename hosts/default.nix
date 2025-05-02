{inputs, ...}: let
  inherit (inputs) self;
  inherit (self) lib;
  system = "x86_64-linux";
  specialArgs = {inherit lib inputs self;};
  baseModules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    ../overlays
    ../modules
  ];
in {
  iso = lib.nixosSystem {
    inherit system specialArgs;
    modules =
      baseModules ++ [./iso];
  };
  flocke = lib.nixosSystem {
    inherit system specialArgs;
    modules =
      baseModules
      ++ [
        ./flocke
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      ];
  };
  schnee = lib.nixosSystem {
    inherit system specialArgs;
    modules =
      baseModules ++ [./schnee];
  };
}
