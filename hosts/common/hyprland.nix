{ config, lib, pkgs, ... }: 

with lib;
let 
  username = config.modules.other.system.username;
  cfg = config.modules.WM.hyprland;

  variant="mocha";

  hyprland-catppuccin = pkgs.stdenv.mkDerivation {
    name = "hyprland-catppuccin";
    version = "b57375545f5da1f7790341905d1049b1873a8bb3v";
    runtimeInputs = with pkgs; [ ];
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "hyprland";
      rev = "b57375545f5da1f7790341905d1049b1873a8bb3";
      hash = "sha256-XTqpmucOeHUgSpXQ0XzbggBFW+ZloRD/3mFhI+Tq4O8=";
    };  
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      
      cp -r "$src"/themes "$out"
      

      runHook postInstall
    '';
  };

  hyprlock-cat = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/logos/exports/1544x1544_circle.png";
    hash = "sha256-A85wBdJ2StkgODmxtNGfbNq8PU3G3kqnBAwWvQXVtqo=";
  };

  hyprlock-catppuccin = pkgs.stdenv.mkDerivation {
    name = "hyprlock-catppuccin";
    version = "0.0";
    runtimeInputs = [ hyprland-catppuccin ];
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "hyprlock";
      rev = "d5a6767000409334be8413f19bfd1cf5b6bb5cc6";
      hash = "sha256-pjMFPaonq3h3e9fvifCneZ8oxxb1sufFQd7hsFe6/i4=";
    };  
    installPhase = ''
      runHook preInstall
      dir="$out/.config/hypr"

      mkdir -p "$dir"
      
      cp $src/hyprlock.conf $dir/hyprlock.conf
      sed -i -e "s~\$HOME/\.config/hypr/mocha.conf~$dir/${variant}.conf~g" "$dir/hyprlock.conf"
      sed -i -e "s~\~/.config/background~${pkgs.catppuccin-wallpapers}/mandelbrot/mandelbrot_full_flamingo.png~g" "$dir/hyprlock.conf"
      sed -i -e "s~\~/.face~${hyprlock-cat}~g" "$dir/hyprlock.conf"
      # sed -i -e "s~\~/.face~/tmp/hyprlock.png~g" "$dir/hyprlock.conf"
      cp "${hyprland-catppuccin}/themes/${variant}.conf" "$dir/${variant}.conf"       

      runHook postInstall
    '';
  };



in
{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rofi-wayland
      waybar 
      hyprpaper
      hyprlock
      hyprland
      hyprshade
      lxqt.lxqt-openssh-askpass
      libdrm

      dunst 
      # wireplumber 
      pciutils # lspci is needed by hyprland
      bluez
      dunst 
      swww
      sway-contrib.grimshot
    ];

    services.logind.lidSwitch = "suspend";
    # hyprland settings
    home-manager.users.${username} = {

      xdg.configFile."hypr/hyprlock.conf".source = "${hyprlock-catppuccin}/.config/hypr/hyprlock.conf";
      # xdg.configFile."background".source = "${pkgs.catppuccin-wallpapers}/mandelbrot/mandelbrot_gap_pink.png";
      # xdg.configFile."hypr/${variant}.conf".source = "${hyprlock-catppuccin}/.config/hypr/${variant}.conf";
      
      services.hypridle = {
        enable = true;
        settings = {
          before_sleep_cmd = "hyprlock";
        };
      };

      programs.waybar.enable = true;
      wayland.windowManager.hyprland.settings = {
        input = {
          kb_layout = "us";
          natural_scroll = true;
          sensitivity = 0;
          kb_variant = "altgr-intl";
          accel_profile = "flat";
          force_no_accel = true;
        };
        general = {
          gaps_in = 2;
          gaps_out = 1;
          border_size = 1;
          # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          # "col.inactive_border" = "rgba(595959aa)";
          layout = "master";
        };
        decoration.rounding = 5;
        misc.disable_hyprland_logo = true;
        animations = {
            enabled = true;
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
        windowrulev2 = [
          "float,title:bluetuith"
          "float,title:nmtui"
        ];
        bind = [
          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          "SUPER, RETURN, exec, footclient"
          "SUPER SHIFT, RETURN, exec, rofi -show drun"
          "SUPER SHIFT, Q, killactive,"
          "SUPER, M, exit, "
          "SUPER, B, exec, footclient --title=bluetuith ${pkgs.bluetuith}/bin/bluetuith"
          "SUPER, N, exec, footclient --title=nmtui ${pkgs.networkmanager}/bin/nmtui"
          "SUPER, A, exec, ${pkgs.ani-cli-advanced}/bin/ani-cli-advanced"
          "SUPER SHIFT, A, exec, ani-cli --rofi -c"
          "SUPER, f, fullscreen"
          "SUPER, E, exec, nautilus --new-window "
          "SUPER, V, togglefloating, "
          "SUPER, P, pseudo, # dwindle"
          "SUPER, S, togglesplit, # dwindle"
          "SUPER, C, exec, /home/vali/.config/wallpaper/colorscheme-setter"
          ",PRINT, exec, mkdir -p ~/Pictures/Screenshots && ${pkgs.sway-contrib.grimshot}/bin/grimshot savecopy anything ~/Pictures/Screenshots/screenshot-$(date -Iminutes).png"

          
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
          ",XF86AudioMute, exec, $ wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];
      };
    };


  };

}
