{
  inputs,
  lib,
  ...
}:
{
  # partly taken from github.com/bloxx12/nichts

  nix = {
    registry = lib.mapAttrs (_: v: { flake = v; }) inputs;
    settings = {
      extra-experimental-features = [
        "flakes" # flakes
        "nix-command" # experimental nix commands
        "cgroups" # allow nix to execute builds inside cgroups
        "pipe-operators"
      ];
      warn-dirty = false;
    };
  };
}
