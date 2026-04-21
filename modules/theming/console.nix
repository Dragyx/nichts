{
  scheme,
  enable,
  mkIf,
  ...
}:
{
  console =
    {
      earlySetup = true;
      colors = scheme.toList;
    }
    |> mkIf enable;
}
