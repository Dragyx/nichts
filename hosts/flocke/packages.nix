# which default packages to use for the system
{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nextcloud-client
    # etcher
    vlc
    thunderbird
    material-icons
    material-design-icons
    spotify
    feh
    # Animeeeeee!
    ani-cli # The stable version is very outdated
    superTuxKart
    # nnn
    pympress
    ocaml
    fuse
  ];
}
