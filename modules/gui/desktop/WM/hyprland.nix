{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.WM.hyprland;
  username = config.modules.system.username;
  monitors = config.modules.system.monitors;
  inherit (lib) mkEnableOption mkIf getExe;
in {
  options.modules.WM.hyprland = {
    enable = mkEnableOption "hyprland";
    gnome-keyring.enable = mkEnableOption "gnome-keyring";
  };

  config = mkIf cfg.enable {
    services.displayManager = {
      sessionPackages = [pkgs.hyprland]; # pkgs.gnome.gnome-session.sessions ];
      defaultSession = "hyprland";
    };

    environment.systemPackages = with pkgs; [
      xwayland
      swww
      hyprshade
      hyprlock
      rofi-wayland
      waybar
      lxqt.lxqt-openssh-askpass
      libdrm
      dunst
      pciutils # lspci is needed by hyprland
      grimblast
      satty
    ];

    programs.xwayland.enable = true;
    programs.hyprland.enable = true;

    services.gnome.gnome-keyring.enable = cfg.gnome-keyring.enable;
    security.pam.services.login.enableGnomeKeyring = cfg.gnome-keyring.enable;

    services.displayManager.sddm.wayland.enable = true;

    home-manager.users.${username} = {
      home.packages = with pkgs; [
        bluetuith
        brightnessctl
        # needed for wayland copy / paste support in neovim
        wl-clipboard
      ];

      xdg.desktopEntries.hyprlock = {
        name = "Hyprlock";
        exec = "${getExe pkgs.hyprlock}";
      };

      services.hypridle = {
        enable = true;
        settings.before_sleep_cmd = "${getExe pkgs.hyprlock}";
      };

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        xwayland.enable = true;
        settings = {
          exec-once =
            (
              if cfg.gnome-keyring.enable
              then ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"]
              else []
            )
            ++ (with pkgs; [
              "${swww}/bin/swww-daemon"
              "${getExe nextcloud-client}"
            ]);
          monitor =
            map (
              m: "${m.device},${toString m.resolution.x}x${toString m.resolution.y}@${toString m.refresh_rate},${toString m.position.x}x${toString m.position.y},${toString m.scale},transform,${toString m.transform}"
            )
            monitors; #TODO: default value
          input = {
            kb_layout = "us";
            kb_variant = "altgr-intl";
            kb_options = "compose:ALT_R";
            sensitivity = 0;
            accel_profile = "flat";
            force_no_accel = true;
            repeat_rate = 50;
            repeat_delay = 200;
          };
          general = {
            gaps_in = 2;
            gaps_out = 1;
            border_size = 1;
            # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            # "col.inactive_border" = "rgba(595959aa)";
            layout = "dwindle";
          };
          cursor.no_hardware_cursors = true;
          decoration.rounding = 5;
          misc.disable_hyprland_logo = true;
          animations = {
            enabled = false;
            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = ["myBezier, 0.05, 0.9, 0.1, 1.05"];

            animation = [
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
              "windows, 1, 7, myBezier"
            ];
          };
          xwayland = {
            force_zero_scaling = true;
          };
          gestures.workspace_swipe = true;
          debug.enable_stdout_logs = true;
          debug.disable_logs = true;
          windowrulev2 = [
            "float,title:bluetuith"
            "float,title:nmtui"
          ];
          # render.explicit_sync = 0; # TODO: Remove this and fix Hyprland
          bind = [
            # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
            "SUPER, RETURN, exec, footclient"
            "SUPER SHIFT, RETURN, exec, rofi -show drun -show-icons"
            "SUPER SHIFT, Q, killactive,"
            "SUPER, B, exec, footclient --title=bluetuith ${pkgs.bluetuith}/bin/bluetuith"
            "SUPER, N, exec, footclient --title=nmtui ${pkgs.networkmanager}/bin/nmtui"
            "SUPER, A, exec, ${pkgs.ani-cli-advanced}/bin/ani-cli-advanced"
            "SUPER SHIFT, A, exec, ani-cli --rofi -c"
            "SUPER, f, fullscreen"
            "SUPER, E, exec, nautilus --new-window "
            "SUPER, V, togglefloating, "
            "SUPER, P, pseudo, # dwindle"
            "SUPER, S, togglesplit, # dwindle"
            ",PRINT, exec, ${getExe pkgs.satty} -f \"$(${getExe pkgs.grimblast} copysave area $(mktemp --suffix .png))\" -o ~/Pictures/Screenshots/screenshot-annotated-$(date -Iseconds).png"

            # Move focus with mainMod + arrow keys"
            "SUPER, h, movefocus, l"
            "SUPER, l, movefocus, r"
            "SUPER, k, movefocus, u"
            "SUPER, j, movefocus, d"

            # move window to next / previous workspace"
            "SUPER CTRL, h, movetoworkspace, r-1"
            "SUPER CTRL, l, movetoworkspace, r+1"

            # move to next / previous workspace"
            "SUPER CTRL, j, workspace, r-1"
            "SUPER CTRL, k, workspace, r+1"

            # Switch workspaces with mainMod + [0-9]"
            "SUPER, 1, workspace, 1"
            "SUPER, 2, workspace, 2"
            "SUPER, 3, workspace, 3"
            "SUPER, 4, workspace, 4"
            "SUPER, 5, workspace, 5"
            "SUPER, 6, workspace, 6"
            "SUPER, 7, workspace, 7"
            "SUPER, 8, workspace, 8"
            "SUPER, 9, workspace, 9"
            "SUPER, 0, workspace, 10"

            # Move active window to a workspace with mainMod + SHIFT + [0-9]"
            "SUPER SHIFT, 1, movetoworkspace, 1"
            "SUPER SHIFT, 2, movetoworkspace, 2"
            "SUPER SHIFT, 3, movetoworkspace, 3"
            "SUPER SHIFT, 4, movetoworkspace, 4"
            "SUPER SHIFT, 5, movetoworkspace, 5"
            "SUPER SHIFT, 6, movetoworkspace, 6"
            "SUPER SHIFT, 7, movetoworkspace, 7"
            "SUPER SHIFT, 8, movetoworkspace, 8"
            "SUPER SHIFT, 9, movetoworkspace, 9"
            "SUPER SHIFT, 0, movetoworkspace, 10"

            "SUPER SHIFT, h, movewindow, l"
            "SUPER SHIFT, l, movewindow, r"
            "SUPER SHIFT, k, movewindow, u"
            "SUPER SHIFT, j, movewindow, d"

            # resize windows
            "SUPER, -, resizeactive, -30"
            "SUPER, +, resizeactive, 30"

            # Scroll through existing workspaces with mainMod + scroll"
            "SUPER, mouse_down, workspace, e+1"
            "SUPER, mouse_up, workspace, e-1"

            # Move/resize windows with mainMod + LMB/RMB and dragging
            "SUPER, mouse:272, movewindow"
            # "bindm = SUPER, mouse:273, resizewindow"
          ];

          bindm = [
            "Super, mouse:272, movewindow"
            "Super, mouse:273, resizewindow"
          ];
          binde = [
            ",XF86MonBrightnessUp, exec, brightnessctl set 10%+"
            ",XF86MonBrightnessDown, exec, brightnessctl set 10%-"
            # Example volume button that allows press and hold, volume limited to 150%"
            ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
            # Example volume button that will activate even while an input inhibitor is active"
            ",XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ];
          env = [
            "XCURSOR_SIZE,24"
          ];
        };
      };
    };
  };
}
