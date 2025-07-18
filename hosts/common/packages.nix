# which default packages to use for the system
{pkgs, ...}: let
  python-packages = ps:
    with ps; [
      pandas
      numpy
      opencv4
      ipython
    ];
in {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (python3.withPackages python-packages)
    man-pages
    discord
    pwvucontrol
    signal-desktop-bin
    pandoc
    texlive.combined.scheme-full
    betterdiscordctl
    television
    firefox
    imv
    yt-dlp
    ghc
    dig
    vim
    bat
    element-desktop
    microfetch
    typst
    prismlauncher
    cm_unicode
    eza
    git
    jujutsu
    comma
    unzip
    calc
    rsync
    evince
    wlr-randr
    gnumake
    python3
    gcc
    gdb
    cargo
    rustc
    rust-analyzer
    clippy
    pkg-config
    nix-index
    nautilus
    btop
    ripgrep

    alsa-utils
    foot

    # image manipulation
    gimp3
    imagemagick

    telegram-desktop
    calc
    tldr

    # partition management
    parted
    gparted

    # nix formatter
    alejandra

    radare2
    # cli markdown viewer
    glow

    dua

    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    hunspellDicts.de_AT
    cbonsai
  ];
}
