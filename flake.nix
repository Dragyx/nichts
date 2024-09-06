{
  description = "lololo";
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    inherit (nixpkgs) lib;
    nixosConfigurations = import ./hosts {inherit inputs;};
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    catppuccin.url = "github:catppuccin/nix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
