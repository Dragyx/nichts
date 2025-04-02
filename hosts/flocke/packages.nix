# which default packages to use for the system
{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # security audits
    lynis
    baobab
    amdvlk
    texlive.combined.scheme-medium
    signal-desktop
    nextcloud-client
    # etcher
    vlc
    audacity
    thunderbird
    openjdk
    # pkgs.nordvpn # nur.repos.LuisChDev.nordvpn
    material-icons
    material-design-icons
    libreoffice
    gimp
    spotify
    flameshot
    feh
    # Animeeeeee!
    ani-cli # The stable version is very outdated
    superTuxKart
    # nnn
    anki
    kdePackages.okular
    pympress
  ];
}
