{ pkgs, ... }:
let
  # nur-no-pkgs = import inputs.nur-no-pkgs { pkgs = inputs.nixpkgs.legacyPackages.${profile-config.system}; nurpkgs = inputs.nixpkgs.legacyPackages.${profile-config.system}; };
  python-packages =
    ps: with ps; [
      pandas
      numpy
      opencv4
      ipython
    ];
in
{
  environment.systemPackages = with pkgs; [
    ani-cli
    ffmpeg
    # android-tools
    nextcloud-client
    (python3.withPackages python-packages)
    vlc
    thunderbird
    openjdk
    material-icons
    material-design-icons
    spotify
    # minecraft
    prismlauncher
    feh
    gamescope
    xorg.xrandr # see configuration.nix: needed for xwayland applications to start on right monitor
    wine
    discord
    betterdiscordctl
  ];
}
