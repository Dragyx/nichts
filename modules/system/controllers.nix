{config, ...}: {
  boot.extraModulePackages = [config.boot.kernelPackages.xpadneo];
}
