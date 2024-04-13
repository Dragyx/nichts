{ config, lib, inputs, pkgs, ... }:
with lib; let
  username = config.modules.other.system.username;
  cfg = config.modules.hyprland;
in {
    options.modules.hyprland.nvidia.enable = mkEnableOption "nvidia";
    options.modules.hyprland = {
        enable = mkEnableOption "hyprland";
	monitor = mkOption {
	    description = "hyprland monitor config";
	    default = ",preferred,auto,1";
	    type = types.listof(types.str);
	};
    };

  config = mkIf cfg.enable {
	  environment.sessionVariables = mkIf cfg.nvidia.enable {
	    LIBVA_DRIVER_NAME = "nvidia";
	    XDG_SESSION_TYPE = "wayland";
	    GBM_BACKEND = "nvidia-drm";
	    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
	    WLR_NO_HARDWARE_CURSORS = "1";
	    SDL_VIDEODRIVER = "wayland";
	    _JAVA_AWT_WM_NONREPARENTING = "1";
	    CLUTTER_BACKEND = "wayland";
	    WLR_RENDERER = "vulkan";
	    XDG_CURRENT_DESKTOP = "Hyprland";
	    XDG_SESSION_DESKTOP = "Hyprland";
	    GTK_USE_PORTAL = "1";
	    NIXOS_XDG_OPEN_USE_PORTAL = "1";
	  };
    programs.hyprland = {
        enable = true;
	xwayland.enable = true;
    };
  xdg.portal.wlr.enable = true;
  xdg.portal.lxqt.enable = false;
  systemd.user.services.xdg-desktop-portal-gnome.enable = false;

    home-manager.users.${username} = {
	    wayland.windowManager.hyprland = {
		enable = true;
		settings = {
			"$mod" = "SUPER";

			input = {
			    kb_layout = "ch";
			};

			bind = [
			    "$mod, Q, killactive"
			    "$mod, return, exec, alacritty"
			    "$mod SHIFT, return, exec, firefox"

			    # Application
			    "$mod SHIFT, c, exec, code"
			    
			    # Monitor management
			    "$mod SHIFT, k, movecurrentworkspacetomonitor, DP-2"
			    "$mod SHIFT, j, movecurrentworkspacetomonitor, DP-1"

			    # Window Management
			    "$mod, left, movefocus, l"
			    "$mod, right, movefocus, r"
			    "$mod, up, movefocus, u"
			    "$mod, down, movefocus, d"
			    "$mod, F, fullscreen"

			    # Screenshot
			    "$mod SHIFT, s, exec, grim -g 'slurp -d' - | wl-copy"
			]
			++ (
			  builtins.concatLists (builtins.genList (
			    x: let
			      ws = let
			        c = (x + 1) / 10;
			      in
			        builtins.toString (x+1-(c * 10));
			    in [
			      "$mod, ${ws}, workspace, ${toString (x+1)}"
			      "$mod SHIFT, ${ws}, movetoworkspace, ${toString(x + 1)}"
			    ]
			  )
			10)
		 );
		};
	    };
	};
  };

}
