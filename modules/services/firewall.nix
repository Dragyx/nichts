{pkgs, ...}: {
  networking.firewall = {
    enable = pkgs.lib.mkDefault true;
    allowedUDPPortRanges = [
      {
        # kdeconnect
        from = 1714;
        to = 1764;
      }
    ];
    allowedTCPPortRanges = [
      {
        # kdeconnect
        from = 1714;
        to = 1764;
      }
    ];
  };
}
