{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  username = config.modules.system.username;
  cfg = config.modules.programs.steam;
in {
  options.modules.programs.steam = {
    enable = mkEnableOption "steam";
    gamescope = mkEnableOption "gamescope";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = mkIf cfg.gamescope true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
      # set LD_PRELOAD to correctly load everything for steam: see https://github.com/ROCm/ROCm/issues/2934
      # TODO: check if this is still relevant
      package = pkgs.steam.overrideAttrs (prevAttrs: {
        nativeBuildInputs =
          (prevAttrs.nativeBuildInputs or [])
          ++ [pkgs.makeBinaryWrapper];
        postInstall =
          (prevAttrs.postInstall or "")
          + ''
            wrapProgram $out/bin/steam --set LD_PRELOAD "${pkgs.libdrm}/lib/libdrm_amdgpu.so"
          '';
      });
    };
    home-manager.users.${username} = {
    };
  };
}
