{inputs, ...}: let
  add_nixpkgs_small = self: super: {
    small = import inputs.nixpkgs-small {system = super.system;};
  };

  add_custom_scripts = self: super: {
    ani-cli-advanced = super.writeShellApplication {
      name = "ani-cli-advanced";
      runtimeInputs = with super; [ani-cli];
      text = ''
        selection=$(printf "\\ueacf Continue\n\\uf002 Search\n\\uea81 Delete History" | rofi -p "ani-cli" -dmenu -i)
        case $selection in
          *Search) ani-cli --rofi;;
          *Continue) ani-cli --rofi -c;;
          "*Delete History") ani-cli -D;;
        esac

      '';
    };
  };

  add_catppuccin_wallpapers = self: super: {
    catppuccin-wallpapers = super.fetchFromGitHub {
      owner = "zhichaoh";
      repo = "catppuccin-wallpapers";
      rev = "1023077979591cdeca76aae94e0359da1707a60e";
      sha256 = "sha256-h+cFlTXvUVJPRMpk32jYVDDhHu1daWSezFcvhJqDpmU=";
    };
  };
in {
  nixpkgs.overlays = [
    add_custom_scripts
    add_catppuccin_wallpapers
    add_nixpkgs_small
  ];
}
