{
  config,
  schemes,
  username,
  mkIf,
  name,
  enable,
  ...
}:
{

  home-manager.users.${username} = mkIf enable {
    xdg.configFile."helix/themes/${name}.toml".source = config.scheme schemes.base16-helix;
    programs.helix.settings.theme = name;
  };
}
