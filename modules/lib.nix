{
  config,
  lib,
  ...
}: let
  inherit (lib) attrNames genAttrs;
  users = attrNames config.modules;
in {
  eachUser = userAttrs: (genAttrs users userAttrs);
  importWithLib = modLib: args: modules: (
    builtins.map (
      mod: import mod (args // {lib = modLib;})
    )
    modules
  );
}
