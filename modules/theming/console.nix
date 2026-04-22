{
  scheme,
  enable,
  mkIf,
  ...
}:
{
  console = mkIf enable {
    earlySetup = true;
    colors = with scheme; [
      base00-hex
      red
      green
      yellow
      blue
      magenta
      cyan
      base05-hex
      base03-hex
      red
      green
      yellow
      blue
      magenta
      cyan
      base07-hex
    ];
  };
}
