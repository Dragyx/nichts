{ inputs, ... }:
let 
  inherit (inputs) self;
  inherit (self) lib;
in {
  # Vali
  mars = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit lib inputs self; };
    modules = [
        ./vali/mars
        ../modules
        inputs.home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default
    ];
  };

  # Lars
  dyonisos = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit lib inputs self; };
    modules = [
        ./lars/dyonisos
        ../modules
        inputs.home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default
    ];
  };

  kronos = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit lib inputs self; };
    modules = [
        ./lars/kronos
        ../modules
        inputs.home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default
    ];
  };

  flocke = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit lib inputs self; };
    modules = [
        ../overlay.nix # TODO: move this somewhere else
        ./dragyx/flocke
        ../modules
        inputs.home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default
    ];
  };
}
