{
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.modules.system.username;
  cfg = config.modules.theming.themes.catppuccin;
  inherit (lib) mkIf mkDefault getExe;

  hyprland-catppuccin = pkgs.stdenv.mkDerivation {
    name = "hyprland-catppuccin";
    version = "b57375545f5da1f7790341905d1049b1873a8bb3v";
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
    runtimeInputs = [hyprland-catppuccin];
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
      sed -i -e "s~\$HOME/\.config/hypr/mocha.conf~$dir/${cfg.flavor}.conf~g" "$dir/hyprlock.conf"
      sed -i -e "s~\~/.config/background~${pkgs.catppuccin-wallpapers}/mandelbrot/mandelbrot_full_flamingo.png~g" "$dir/hyprlock.conf"
      sed -i -e "s~\~/.face~${hyprlock-cat}~g" "$dir/hyprlock.conf"
      # sed -i -e "s~\~/.face~/tmp/hyprlock.png~g" "$dir/hyprlock.conf"
      cp "${hyprland-catppuccin}/themes/${cfg.flavor}.conf" "$dir/${cfg.flavor}.conf"

      runHook postInstall
    '';
  };
  # FIXME: use a better source for the image
  catppuccin-icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/logos/exports/1544x1544_circle.png";
    hash = "sha256-A85wBdJ2StkgODmxtNGfbNq8PU3G3kqnBAwWvQXVtqo=";
  };
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      hyprlock
    ];

    services.logind.lidSwitch = "suspend";
    # hyprland settings
    home-manager.users.${username} = {
      xdg.configFile."hypr/hyprlock.conf".source = "${hyprlock-catppuccin}/.config/hypr/hyprlock.conf";
      # We unfortunatly need to always create the icon because
      # we can not conditionally set the name as it is dependent
      # on the resulting config attributeset, which is again dependent
      # on us setting the attribute or not. (-> infinite recursion)
      #
      # Just, to be safe, we set the hyprlock executable,
      # since this would otherwise cause the rebuild to fail
      # when catppuccin is not enabled as the `hyprlock` attributeset would
      # be created without the exec attribute being set :(
      xdg.desktopEntries.hyprlock = {
        name = mkDefault "Hyprlock";
        icon = "${catppuccin-icon}";
        exec = "${getExe pkgs.hyprlock}";
      };
      # xdg.configFile."background".source = "${pkgs.catppuccin-wallpapers}/mandelbrot/mandelbrot_gap_pink.png";
      # xdg.configFile."hypr/${flavor}.conf".source = "${hyprlock-catppuccin}/.config/hypr/${flavor}.conf";
      wayland.windowManager.hyprland.settings.exec-once = [
        "${getExe pkgs.wayneko} --layer overlay --follow-pointer false"
      ];
    };
  };
}
