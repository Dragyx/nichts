{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.login.greetd;
  session = config.modules.login.session;
in {
  options.modules.login.greetd.enable = mkEnableOption "greetd";
  #TODO: move somewhere else
  options.modules.login.session = mkOption {
    type = types.str;
    description = "Which login session to start";
  };

  config = mkIf cfg.enable {
    # login manager
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
              -c \"${session}\" \
              -r 
              -t --time-format "DD.MM.YYYY"
              --asteriks'';
        };
      };
    };
  };
}
