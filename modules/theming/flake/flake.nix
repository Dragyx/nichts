{
  description = "Internal flake used for theming";
  inputs = {
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    base16-helix = {
      url = "github:tinted-theming/base16-helix";
      flake = false;
    };
    tinted-limine = {
      url = "github:Dragyx/tinted-limine";
      flake = false;
    };
  };
  outputs = inputs@{ ... }: inputs;
}
