{
  config,
  schemes,
  ...
}:
{
  boot.loader.limine.extraConfig = config.scheme schemes.tinted-limine |> builtins.readFile;
}
