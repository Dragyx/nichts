{
  inputs,
  lib,
  pkgs,
  ...
}: {
  # partly taken from github.com/bloxx12/nichts

  nix = {
    package = pkgs.lix;

    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;
    settings = {
      extra-experimental-features = [
        "flakes" # flakes
        "nix-command" # experimental nix commands
        "cgroups" # allow nix to execute builds inside cgroups
      ];
      warn-dirty = false;
    };
  };
}
