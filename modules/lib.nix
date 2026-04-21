{
  config,
  lib,
  ...
}:
let
  inherit (lib) attrNames genAttrs;
  users = attrNames config.modules;
in
{
  eachUser = userAttrs: (genAttrs users userAttrs);
  importWithLib =
    modLib: args: modules:
    (map (
      mod: if builtins.isFunction mod then import mod (args // { lib = modLib; }) else import mod
    ) modules);
}
