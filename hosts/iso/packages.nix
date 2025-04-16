# which default packages to use for the system
{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # security audits
    nextcloud-client
    vlc
    thunderbird
    material-icons
    material-design-icons
    libreoffice
    gimp
    spotify
    ani-cli # The stable version is very outdated
  ];
}
