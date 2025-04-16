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
    pandoc
    texlive.combined.scheme-small
    betterdiscordctl
    television
    anki
    imv
    yt-dlp
    ghc
    qmk
    vim
    bat
    # nheko
    # calibre
    element-desktop
    neovim
    typst
    prismlauncher
    cm_unicode
    eza # exa is unmaintained
    hwinfo
    git
    broot
    unzip
    calc
    rsync
    evince
    wlr-randr
    wget
    gnumake
    zoxide
    python3
    sioyek
    nodejs
    gcc
    gdb
    cargo
    rustc
    rust-analyzer
    clippy
    lsof
    htop
    smartmontools
    # networkmanager
    pkg-config
    sof-firmware # audio
    # easyeffects currently throws an error
    nix-index
    # --------- optional
    sherlock
    nautilus
    ranger
    nitch

    plocate
    alsa-utils
    foot

    # image manipulation
    gimp
    imagemagick

    telegram-desktop
    tg

    calc
    tldr

    # partition management
    parted

    # nix formatter
    alejandra

    radare2
    # cli markdown viewer
    glow

    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    hunspellDicts.de_AT
    cbonsai
  ];
}
