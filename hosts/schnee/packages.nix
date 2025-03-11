{pkgs, ...}: let
  # nur-no-pkgs = import inputs.nur-no-pkgs { pkgs = inputs.nixpkgs.legacyPackages.${profile-config.system}; nurpkgs = inputs.nixpkgs.legacyPackages.${profile-config.system}; };
  python-packages = ps:
    with ps; [
      pandas
      numpy
      opencv4
      ipython
      # bt-dualboot for synching up bluetooth between Windows and Linux
      (
        buildPythonPackage rec {
          pname = "bt-dualboot";
          version = "1.0.1";
          src = fetchPypi {
            inherit pname version;
            sha256 = "sha256-pjzGvLkotQllzyrnxqDIjGlpBOvUPkWpv0eooCUrgv8=";
          };
          doCheck = false;
          propagatedBuildInputs = [
            pkgs.chntpw
          ];
        }
      )
    ];
in {
  environment.systemPackages = with pkgs; [
    ani-cli
    # texliveFull
    # android-tools
    signal-desktop
    nextcloud-client
    (python3.withPackages python-packages)
    vlc
    audacity
    thunderbird
    openjdk
    material-icons
    material-design-icons
    libreoffice
    spotify
    # minecraft
    prismlauncher
    # window manager
    hyprland-protocols
    flameshot
    feh
    gamescope
    xorg.xrandr # see configuration.nix: needed for xwayland applications to start on right monitor
    wine
    discord
    betterdiscordctl
  ];
}
