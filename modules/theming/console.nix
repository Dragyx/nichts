{
  colors,
  enable,
  mkIf,
  ...
}:
{
  console =
    {
      earlySetup = true;
      colors = colors.toList;
    }
    |> mkIf enable;
}
