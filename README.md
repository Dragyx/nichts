# nichts

My personal collection of NixOS configuration files

## TODO

## Project Structure

```
.
├── flake.lock
├── flake.nix
├── hosts
│   ├── common
│   │   ├── configuration.nix
│   │   ├── default.nix
│   │   └── packages.nix
│   ├── default.nix
│   ├── flocke
│   │   ├── configuration.nix
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   └── packages.nix
│   ├── iso
│   │   ├── configuration.nix
│   │   ├── default.nix
│   │   ├── hardware-configuration.nix
│   │   ├── hardware-configuration2.nix
│   │   └── packages.nix
│   └── schnee
│       ├── configuration.nix
│       ├── default.nix
│       ├── hardware-configuration.nix
│       └── packages.nix
├── LICENSE
├── modules
│   ├── cli
│   │   ├── atuin.nix
│   │   ├── default.nix
│   │   ├── fish.nix
│   │   ├── git.nix
│   │   ├── neovim.nix
│   │   ├── nh.nix
│   │   ├── ranger.nix
│   │   ├── starship.nix
│   │   ├── zellij.nix
│   │   └── zsh.nix
│   ├── default.nix
│   ├── gui
│   │   ├── browsers
│   │   │   ├── default.nix
│   │   │   ├── firefox.nix
│   │   │   ├── librewolf.nix
│   │   │   └── schizofox.nix
│   │   ├── default.nix
│   │   ├── desktop
│   │   │   ├── cursor.nix
│   │   │   ├── default.nix
│   │   │   ├── greetd.nix
│   │   │   ├── gtk.nix
│   │   │   ├── qt.nix
│   │   │   ├── rofi.nix
│   │   │   ├── waybar.nix
│   │   │   └── WM
│   │   │       ├── bar.qml
│   │   │       ├── cosmic.nix
│   │   │       ├── default.nix
│   │   │       ├── hyprland.nix
│   │   │       ├── i3
│   │   │       │   ├── default.nix
│   │   │       │   ├── i3-new.nix
│   │   │       │   └── polybar.sh
│   │   │       └── quickshell.nix
│   │   ├── dev
│   │   │   ├── default.nix
│   │   │   └── vivado.nix
│   │   ├── gaming
│   │   │   ├── default.nix
│   │   │   ├── minecraft.nix
│   │   │   ├── steam.nix
│   │   │   └── vesktop.nix
│   │   ├── media
│   │   │   ├── default.nix
│   │   │   ├── mpv.nix
│   │   │   ├── obs.nix
│   │   │   └── zathura.nix
│   │   ├── misc
│   │   │   ├── default.nix
│   │   │   └── protonvpn.nix
│   │   └── terminals
│   │       ├── alacritty.nix
│   │       ├── default.nix
│   │       ├── foot.nix
│   │       └── kitty.nix
│   ├── services
│   │   ├── default.nix
│   │   ├── firewall.nix
│   │   ├── pipewire.nix
│   │   └── ssh.nix
│   ├── system
│   │   ├── auto-partition.nix
│   │   ├── bluetooth.nix
│   │   ├── default.nix
│   │   ├── fonts.nix
│   │   ├── gpu
│   │   │   ├── default.nix
│   │   │   └── nvidia.nix
│   │   ├── home-manager.nix
│   │   ├── monitors.nix
│   │   ├── network.nix
│   │   ├── nix
│   │   │   ├── default.nix
│   │   │   └── nix.nix
│   │   ├── preserve-system.nix
│   │   └── system.nix
│   ├── theming
│   │   ├── base
│   │   │   └── default.nix
│   │   ├── catppuccin
│   │   │   ├── catppuccin
│   │   │   ├── cursor.nix
│   │   │   ├── default.nix
│   │   │   ├── firefox.nix
│   │   │   ├── hyprland.nix
│   │   │   ├── test_waybar_with_theme.sh
│   │   │   ├── waybar.css
│   │   │   ├── waybar.nix
│   │   │   └── zathura.nix
│   │   ├── default.nix
│   │   └── options.nix
│   └── tui
│       ├── btop.nix
│       ├── default.nix
│       ├── helix
│       │   ├── default.nix
│       │   ├── helix.nix
│       │   └── languages.nix
│       ├── neovim.nix
│       ├── newsboat.nix
│       ├── radare2
│       │   ├── default.nix
│       │   ├── radare2.nix
│       │   └── radare2rc
│       └── yazi.nix
├── notes.md
├── overlay.nix
└── README.md
```
