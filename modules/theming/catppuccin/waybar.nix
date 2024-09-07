{
  config,
  enabled,
  lib,
  ...
}: let
  username = config.modules.system.username;
  style = ''
    * {
      font-family: FantasqueSansMono Nerd Font;
      font-size: 14px;
      min-height: 0;
    }

    #waybar {
      background: transparent;
      color: @text;
      margin: 2px 2px;
    }

    #workspaces {
      border-radius: 0.5rem;
      margin: 5px;
      background-color: @surface0;
      margin-left: 1rem;
    }

    #workspaces button {
      color: @lavender;
      font-family: JetBrains Mono;
      border-radius: 0.5rem;
      padding: 0.1rem;
      font-size: 30px;
    }

    #workspaces button.active {
      color: @sky;
      border-radius: 1rem;
      font-size: 30px;
    }

    #workspaces button:hover {
      color: @sapphire;
      border-radius: 1rem;
      font-size: 30px;
    }

    #custom-music,
    #tray,
    #backlight,
    #clock,
    #battery,
    #pulseaudio,
    #network,
    #wireplumber,
    #custom-lock,
    #custom-power {
      background-color: @surface0;
      padding: 0.5rem 1rem;
      margin: 0.1rem 0;
    }

    #clock {
      color: @blue;
      border-radius: 0px;
    }

    #battery {
      color: @green;
      border-radius: 0px 1rem 1rem 0px;
      margin-right: 1rem;
    }

    #battery.charging {
      color: @green;
    }

    #battery.warning:not(.charging) {
      color: @red;
    }

    #backlight {
      color: @yellow;
      border-radius: 1rem 0px 0px 1rem
    }

    #pulseaudio {
      color: @blue;
      border-radius: 0px 1rem 1rem 0px;
      margin-right: 1rem;
    }

    #network {
      color: @sky;
      border-radius: 1rem 0px 0px 1rem;
      margin-left: 1rem;
    }

    #wireplumber {
      color: @green;
      border-radius: 0px 1rem 1rem 0px;
      margin-right: 1rem;
    }

    #custom-music {
      color: @mauve;
      border-radius: 1rem;
    }

    #custom-lock {
        border-radius: 1rem 0px 0px 1rem;
        color: @lavender;
    }

    #custom-power {
        margin-right: 1rem;
        border-radius: 0px 1rem 1rem 0px;
        color: @red;
    }

    #tray {
      margin-right: 1rem;
      border-radius: 1rem;
    }'';
in {
  config = lib.mkIf enabled {
    home-manager.users.${username} = {
      programs.waybar.style = style;
    };
  };
}
