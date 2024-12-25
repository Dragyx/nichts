{pkgs, ...}: {
  networking.firewall = {
    enable = pkgs.lib.mkDefault true;
  };
}
