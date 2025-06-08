args @ {
  lib,
  config,
  ...
}: let
  lib' =
    lib
    // (
      import ./lib.nix {
        inherit config lib;
      }
    );
in {
  imports = lib'.importWithLib lib' args [
    ./cli
    ./gui
    ./tui
    ./services
    ./theming
    ./system
  ];
}
